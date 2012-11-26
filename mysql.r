REBOL [
	Title: "mySQL client"
	Author: "Nenad Rakocevic"
	Email: dockimbel@free.fr
	Date: 25/07/2001
	File: %mysql-client.r
	Version: 0.9.5
	Purpose: "A simple command-line mySQL client app"
	History: [
		-- 0.9.0 30/01/2001 "First beta release."
		-- 0.9.1 06/02/2001 "Affected rows now displayed"
		-- 0.9.2 07/02/2001 "Table wrong formatting with empty cols. Fixed."
		-- 0.9.3 12/02/2001 "NULL values now displayed."
		-- 0.9.4 13/03/2001 {
				- 'status command added.
				- Default values for 'host and 'user.
		}
		-- 0.9.5 25/07/2001 {
				- App renamed to "mySQL client".
				- Little code clean-up.
				- Added 'source command.
		}
	]
	Comment: "mySQL protocol must be already loaded"
	Usage: {
		>> do %mysql-client.r
		>> mysql
		Host?>  	<server address or hit ENTER for 'localhost>
		User?>  	<a valid user name or hit ENTER for 'root>
		Password?>	<a valid password or hit ENTER if no password>
		Database?>	<a valid database name or hit ENTER for no database selection>
		
		When you get the "mysql>" prompt, you're logged into the server.
		Type 'help to see the command list.
	}
	Notes: {
		Under Windows, you can suppress the text wrapping on screen by
		changing the console settings in the 'file menu. Uncheck
		"Use window width" and set terminal width to a big value.
		(400 should be enough for most cases)
	}
	GIT-ID:	"$Id$"
]

do %mysql-protocol.r

ctx-mysql-client: context [
	db: none
	size-list: none
	version: system/script/header/version
	nl: newline
	
;--- Table-like formatting functions ---

	show-null: func [data][either none? data ["NULL"][data]]
	
	align-left: func [data [string!] len [integer!]][
		head insert/dup tail data " " len - length? data
	]
	
	make-separator-line: func [/local line][
		line: make string! 80
		foreach size size-list [
			append line "+"
			insert/dup tail line "-" size + 2
		]
		append line "+"
	]
	
	make-col-line: func [cols [block!] /local line][
		line: make string! 80
		forall cols [
			append line rejoin [ "| " align-left cols/1/name (pick size-list
				index? cols) + 1 ]
		]
		append line "|"
	]
	
	
	make-row-line: func [row [block!] /local line][
		line: make string! 80
		forall row [
			append line rejoin [ "| " align-left form show-null row/1 (pick
				size-list index? row) + 1 ]
		]
		append line "|"
	]
	
	form-table: func [rows /local columns row len sep-line i][ 
		if not block? rows [return]
		columns: db/locals/columns
		size-list: array/initial length? columns -1
		foreach row rows [
			forall row [
				i: index? row
				len: length? form row/1
				if len > size-list/:i [
					poke size-list i max len length? columns/:i/name
				]
			]
		]
		print sep-line: make-separator-line
		print make-col-line columns
		print sep-line
		forall rows [print make-row-line rows/1]
		print sep-line
		print [length? head rows "row(s) in set"]
		clear size-list
		clear columns
	]
	
;--- Client engine ---

	do-banner: does [
		print [
			"Welcome to the MySQL client version" version
			".  Commands end with ;." nl
		 	"The server version is:" db/locals/version nl
		 	"Type 'help' or '?' for help." nl
		 	nl
		 	"*** warning: multiline mode not yet supported ***" nl
		]
	]
	
	do-help: does [
		print rejoin [ nl
			"MySQL commands:" nl nl
			;"Note that all text commands end with ';'" nl
			"help       Display this help." nl
			"?          Synonym for `help'." nl
			;"connect (\r)    Reconnect to the server. Optional arguments are db and host."
			;"ego     (\G)    Send command to mysql server, display result vertically."
			"exit       Exit mysql. Same as quit." nl
			;"go      (\g)    Send command to mysql server."
			;"notee   (\t)    Don't write into outfile."
			"quit       Quit mysql." nl
			"source     Execute a SQL script file. Takes a file name as an argument." nl
			"status     Get status information from the server." nl
			;"tee     (\T)    Set outfile [to_outfile]. Append everything into given outfile."
			"use        Use another database. Takes database name as argument." nl
			nl
			"everything else will be sent directly to the server." nl
		]
	]

	do-status: func [arg [string!] /local stats uptime uhost][
		stats: insert db [statistics]
		uptime: to-time to-integer second parse stats ""
		print rejoin [
			"--------------" nl
			"mySQl client"	tab tab 	"v" version " for Rebol/Core" nl
			nl
			"Connection id:" tab tab 	db/locals/thread-id nl
			"Current database:"	tab
				either found? db/target [db/target][""] nl
			"Current user:"	tab tab 	db/user "@"
			either error? try [uhost: read join dns:// read dns://localhost]
				["<unresolved>"][uhost] nl
			"Server version:" tab tab 	db/locals/version nl
			"Protocol version:" tab 	db/locals/protocol nl
			"Connection:" tab tab tab 	db/host " via TCP/IP" nl
		;	"Language:" tab tab nl
			"TCP port:" tab tab tab 	db/port-id nl
			"Uptime:" tab tab tab tab
				either not zero? uptime/hour [reform [uptime/hour "hour "]][""]
				either not zero? uptime/minute [reform [uptime/minute "min "]][""]
				uptime/second " sec" nl
			nl
			trim/head find stats "  " nl
			"--------------" nl
		]
	]
	
	do-source: func [arg [string!]][
		either error? try [arg: to-file trim skip arg 7][
			print "ERROR: not a valid file!"
		][
			either exists? to-file arg [
				print "Executing SQL from file..."
				arg: parse/all read to-file arg ";"
				forall arg [print first arg do-query any [first arg ""]]
				print "Done."
			][print "ERROR: Cannot access this file!"]
		]
	]
	
	do-query: func [arg [string!] /local err mr res][
		if error? err: try [
			insert db arg
			res: copy db
			either res = [] [print "Empty set.^/"][form-table res]
			recycle
			mr: db/locals/matched-rows
			if all [mr not zero? mr][
				print ["Query OK." mr "row(s) affected." nl]
			]
			true				 ; 'try [..] have to return a value
		][
			err: disarm err
			print err/arg1
		]
	]
	
	do-use: func [arg [string!]][
		do-query arg
		if not db/locals/error-code [print "Database changed."]
	]
	
	set 'mysql func [ /local spec err cmd db-name][
		if not find first system/schemes 'mySQL [
			print "Error: mySQL protocol not found!"
			exit
		]
		forever [
			spec: make port! [
				scheme: 'mysql
				if empty? host: ask "Host? (Enter=localhost)> " [host: "localhost"]
				if empty? user: ask "User? (Enter=root)> " [user: "root"]
				pass: ask/hide "Password? (Enter=no)> "
				target: ask "Database? (Enter=no)> "
			]
			either error? err: try [
				db: open spec
			][
				err: disarm err
				print ["Error:" err/arg1]
			][break]
		]
		do-banner
		forever [
			cmd: ask "mysql> "
			parse cmd: trim cmd [
				[["exit"| "quit"] to end (close db halt)]	; 'exit or 'return don't
				| [["help" | "?"] to end (do-help)] 		; work here !?
				| [ "use" copy db-name to end (
					do-use cmd
					if not empty? trim db-name [db/target: pick parse db-name ";" 1]
				  )]
				| [ "status" to end (do-status cmd)]
				| [ "source" to end (do-source cmd)]
				| to end (do-query cmd)
			]
		]
	]
]

mysql
