REBOL [
    Title: "Simple wrapper for the mysql:// protocol"
    Author: "Gabriele Santilli <giesse@writeme.com>"
    File: %mysql-wrapper.r
    Date: 10-Jun-2006
    Version: 1.8.0 ; majorv.minorv.status
                   ; status: 0: unfinished; 1: testing; 2: stable
    History: [
        17-Feb-2001 1.1.0 "History start"
         3-Jun-2001 1.2.0 "Dropped dbms.r compatibility"
        24-Jun-2001 1.3.0 {Now FORM-SQL '__LAST-ID gives "LAST_INSERT_ID()"}
        24-Jun-2001 1.4.0 "New: db-last-insert-id"
        24-Jun-2001 1.5.0 "New: db-cached-query"
        24-Jun-2001 1.6.0 "Now using mysql-protocol 0.8.6"
        25-Jul-2001 1.7.0 "Form-sql mapped to mysql driver's 'to-sql function. -DocKimbel"
        10-Jun-2006 1.8.0 "Added 'db-extract-values function -DocKimbel"
    ]
	GIT-ID:	"$Id$"
]

ctx-dbms: make object! [
    set 'form-sql get in system/schemes/mySQL/handler 'to-sql
    
    form-values: func [
        "Form an object/block for SQL INSERT"
        row [block! object!]
        /local result
    ] [
        either object? row [
            rejoin [form-sql next first row " VALUES " form-sql next second row]
        ] [
            join "VALUES " form-sql row
        ]
    ]
    
    set 'db-append func [
        "Appends a row to the table" [catch]
        db [port!] "Database port"
        table [any-string! word!]
        row [block! object!] "Row to append; it has to make sense!"
    ] [
        insert db rejoin [
            "INSERT INTO " table " " form-values row
        ]
    ]
    
    make-row-object: func [
        columns [block! none!]
        /local result
    ] [
        if not columns [return make object! []]
        result: clear []
        foreach column columns [
            insert tail result to-set-word column/name
        ]
        insert tail result [none]
        make object! result
    ]
    
    set 'db-foreach func [
        "Does a block for each row in the table that matches the query" [catch]
        'word [word!] "Word set to the row *OBJECT* for each iteration"
        db [port!] "Database port"
        query [string!] "SELECT etc."
        body [block!] "Code to evaluate for each iteration"
        /local row-object row columns
    ] [
        insert db query
        body: func reduce [word] body
        row: first db
        row-object: make-row-object db/locals/columns
        columns: bind copy next first row-object in row-object 'self
        while [not empty? row] [
            set columns row/1
            body row-object
            row: first db
        ]
    ]
    
    set 'db-pick func [
    	"Does a select and picks the n-th result only" [catch]
        db [port!] "Database port"
        query [string!] "SELECT etc. (without LIMIT!)"
        n [integer!]
        /local row row-object
    ] [
    	insert db join query [" LIMIT " n - 1 ",1"]
        row: first db
        if empty? row [return none]
        row-object: make-row-object db/locals/columns
        set bind copy next first row-object in row-object 'self row/1
        row-object
    ]

    set 'db-change func [
    	"Creates and executes an UPDATE query" [catch]
        db [port!] "Database port"
        table [any-string! word!] "Table name"
        where [string!] "WHERE clause"
        row [object!] "Columns to change"
        /local query
    ] [
        query: join "UPDATE " [table " SET "]
        foreach word next first row [
            insert tail query reduce [form word "=" form-sql get in row word ","]
        ]
        change back tail query " WHERE "
        insert tail query where
        insert db query
    ]
    
    set 'db-last-insert-id func [
        "Gets the last insert id generated by MySQL"
        db [port!] "Database port"
    ] [
        insert db "SELECT LAST_INSERT_ID()"
        first first first db
    ]
    
    set 'db-cached-query func [
        "Creates a cached query (optimized for multiple sequential accesses)"
        db [port!] "Database port"
        query [string!] "SELECT etc. (without LIMIT!)"
    ] [
        context [
            db-port: db
            query-string: query
            n-cache: array 256
            result-cache: array 256
            pick: none
            use [sys-pick] [
                sys-pick: get in system/words 'pick
                pick: func [
                    "Picks the n-th result from the query"
                    n [integer!] "first is 1"
                    /local cn res
                ] [
                    cn: 255 and n + 1
                    either n = sys-pick n-cache cn [
                        sys-pick result-cache cn
                    ] [
                        poke n-cache cn n
                        poke result-cache cn res: db-pick db-port query-string n
                        res
                    ]
                ]
            ]
        ]
    ]
    
    ; -- contribution by Will Arp
    
    set 'db-extract-values func [
		"Get list of values from set or enum fields in mysql"
		table [string! word!]
		column [string! word!]
		db [port!] "Database port"
		/local item list
	] [
		list: make block! 0
		insert db rejoin [{SHOW COLUMNS FROM '} table {' LIKE '} column {'}]
		parse second first copy db [
			any [thru {'} copy item to {'} (insert tail list item) to ","]
		]
		list
	]
]
