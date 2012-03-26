REBOL [
	Title: "MySQL Protocol"
	Author: "Nenad Rakocevic / SOFTINNOV"
	Email: mysql@softinnov.com
	Web: http://softinnov.org/rebol/mysql.shtml
	Date: 12/07/2008
	File: %mysql-protocol.r
	Version: 1.2.1
	Purpose: "MySQL Driver for REBOL"
]

make root-protocol [

	scheme: 'MySQL
	port-id: 3306
	port-flags: system/standard/port-flags/pass-thru or 32 ; /binary

	sql-buffer: make string! 1024
	not-squote: complement charset "'"
	not-dquote: complement charset {"}

	copy*:		get in system/words 'copy
	insert*:	get in system/words 'insert
	pick*:		get in system/words 'pick
	close*:		get in system/words 'close
	set-modes*: get in system/words 'set-modes
	net-log: get in net-utils 'net-log	

	std-header-length: 4
	std-comp-header-length:	3
	end-marker: 254

	throws: [closed "closed"]

;------ Internals --------

	defs: compose/deep [
		cmd [
			;sleep			0
			quit			1
			init-db			2
			query			3
			;field-list		4
			create-db		5
			drop-db			6
			reload			7
			shutdown		8
			statistics		9
			;process-info	10
			;connect		11
			process-kill	12
			debug			13
			ping			14
			;time			15
			;delayed-insert	16
			change-user		17
		]
		refresh [
			grant		1	; Refresh grant tables
			log			2	; Start on new log file
			tables		4	; Close all tables 
			hosts		8	; Flush host cache
			status		16	; Flush status variables
			threads		32	; Flush status variables
			slave		64	; Reset master info and restart slave thread
			master		128 ; Remove all bin logs in the index
		]					; and truncate the index
		types [
			0		decimal
			1		tiny
			2		short
			3		long
			4		float
			5		double
			6		null
			7		timestamp
			8		longlong
			9		int24
			10		date
			11		time
			12		datetime
			13		year
			14		newdate
			15		var-char
			16		bit
            246		new-decimal
			247		enum
			248		set
			249		tiny-blob
			250		medium-blob
			251		long-blob
			252		blob
			253		var-string
			254		string
			255		geometry
		]
		flag [
			not-null		1		; field can't be NULL
			primary-key		2		; field is part of a primary key
			unique-key 		4		; field is part of a unique key
			multiple-key	8		; field is part of a key
			blob			16
			unsigned		32
			zero-fill		64
			binary			128
			enum			256		; field is an enum
			auto-increment	512		; field is a autoincrement field
			timestamp		1024	; field is a timestamp
			set				2048	; field is a set
			num				32768	; field is num (for clients)
		]
		client [
			long-password		1		; new more secure passwords
			found-rows			2		; Found instead of affected rows
			long-flag			4		; Get all column flags
			connect-with-db		8		; One can specify db on connect
			no-schema			16		; Don't allow db.table.column
			compress			32		; Can use compression protcol
			odbc				64		; Odbc client
			local-files			128		; Can use LOAD DATA LOCAL
			ignore-space		256		; Ignore spaces before '('
			protocol-41			512		; Use new protocol (was "Support the mysql_change_user()")
			interactive			1024	; This is an interactive client
			ssl					2048	; Switch to SSL after handshake
			ignore-sigpipe		4096	; IGNORE sigpipes
			transactions		8196	; Client knows about transactions
			reserved			16384	; protocol 4.1 (old flag)
			secure-connection	32768	; use new hashing algorithm
			multi-queries		65536	; enable/disable multiple queries support
    		multi-results		131072	; enable/disable multiple result sets
    		ps-multi-results	(shift/left 1 18)	; multiple result sets in PS-protocol
			plugin-auth			(shift/left 1 19) ; Client supports plugin authentication
			ssl-verify-server-cert	(shift/left 1 30)
			remember-options		(shift/left 1 31)
		]
	]

	locals-class: make object! [
	;--- Internals (do not touch!)---
		seq-num: 0
		buf-size: cache-size: 10000
		last-status:
		stream-end?:
		buffer: none
		cache: none
	;-------
		auto-commit: on		; not used, just reserved for /Command compatibility.
		rows: 10			; not used, just reserved for /Command compatibility.
		auto-conv?: on
		auto-ping?: on
		flat?: off
		newlines?: value? 'new-line
		init:
		matched-rows:
		columns:
		protocol:
		version:
		thread-id:
		crypt-seed:
		capabilities:
		error-code:
		error-msg:
		conv-list: 
		character-set:
		server-status:
		seed-length:
		auth-v11: none
	]

	column-class: make object! [
		table: name: length: type: flags: decimals: none
	]
	
	my-to-date: func [v][any [attempt [to date! v] 1-jan-0000]]
	my-to-datetime: func [v][any [attempt [to date! v] 1-jan-0000/00:00]]
	
	conv-model: [
		decimal			[to decimal!]
		tiny			[to integer!]
		short			[to integer!]
		long			[to integer!]
		float			[to decimal!]
		double			none
		null			none
		timestamp		none
		longlong		none
		int24			[to integer!]
		date			[my-to-date]
		time			[to time!]
		datetime		[my-to-datetime]
		year			[to integer!]
		newdate			none
		var-char		none
		bit				none
		new-decimal		[to decimal!]
		enum			none
		set				none
		tiny-blob		none
		medium-blob		none
		long-blob		none
		blob			none
		var-string		none
		string			none
		geometry		none
	]
	
	set 'change-type-handler func [p [port!] type [word!] blk [block!]][
		head change/only next find p/locals/conv-list type blk
	]
	
	convert-types: func [
		p [port!]
		rows [block!] 
		/local row i convert-body action cols col conv-func tmp
	][
		cols: p/locals/columns
		convert-body: make block! 1
		action: [if tmp: pick* row (i)]
		foreach col cols [
			i: index? find cols col
			if 'none <> conv-func: select p/locals/conv-list col/type [
				append convert-body append/only compose action head
					insert* at compose [change at row (i) :tmp] 5 conv-func
			]
		]
		if not empty? convert-body [
			either p/locals/flat? [
				while [not tail? rows][
					row: rows
					do convert-body
					rows: skip rows length? cols
				]
			][
				foreach row rows :convert-body
			]
		]
	]
	
	decode: func [int [integer!] /features /flags /type /local list name value][
		either type [
			any [select defs/types int 'unknown]
		][
			list: make block! 10
			foreach [name value] either flags [defs/flag][defs/client][
				if value = (int and value) [append list :name]	
			]
			list
		]
	]
	
	encode-refresh: func [blk [block!] /local total name value][
		total: 0
		foreach name blk [
			either value: select defs/refresh :name [
				total: total + value
			][
				net-error reform ["Unknown argument:" :name]
			]
		]
		total
	]

	sql-chars: charset sql-want: {^(00)^/^-^M^(08)'"\}
	sql-no-chars: complement sql-chars
	escaped: make hash! [
		#"^(00)"	"\0"
		#"^/" 		"\n"
		#"^-" 		"\t"
		#"^M" 		"\r"
		#"^(08)" 	"\b"
		#"'" 		"\'"
		#"^""		{\"}
		#"\" 		"\\"
	]

	set 'sql-escape func [value [string!] /local c][
		parse/all value [
			any [
				c: sql-chars (c: change/part c select escaped c/1 1) :c 
				| sql-no-chars
			]
		]
		value
	]

	set 'to-sql func [value /local res][
		switch/default type?/word value [
			none!	["NULL"]
			date!	[
				rejoin ["'" value/year "-" value/month "-" value/day
					either value: value/time [
						rejoin [" " value/hour	":" value/minute ":" value/second]
					][""] "'"
				]
			]
			time!	[join "'" [value/hour ":" value/minute ":" value/second "'"]]
			money!	[head remove find mold value "$"]
			string!	[join "'" [sql-escape copy* value "'"]]
			binary!	[to-sql to string! value]
			block!	[
				if empty? value: reduce value [return "()"]
				res: append make string! 100 #"("
				forall value [repend res [to-sql value/1 #","]]
				head change back tail res #")"
			]
		][
			either any-string? value [to-sql form value][form value]
		]
	]
	
	map-rebol-values: func [data [block!] /local args sql mark][
		args: reduce next data
		sql: copy* pick* data 1
		mark: sql
		while [mark: find mark #"?"][
			mark: insert* remove mark either tail? args ["NULL"][to-sql args/1]
			if not tail? args [args: next args]
		]
		net-log sql
		sql
	]
	
	show-server: func [obj [object!]][
		net-log reform [											newline
			"----- Server ------" 									newline
			"Version:"					obj/version					newline
			"Protocol version:"			obj/protocol 				newline
			"Thread ID:" 				obj/thread-id 				newline
			"Crypt Seed:"				obj/crypt-seed				newline
			"Capabilities:"				mold decode/features 		obj/capabilities 		newline
			"Seed length:"				obj/seed-length 			newline
			"-------------------"
		]	
	]

;------ Encryption support functions ------

	scrambler: make object! [
		to-pair: func [value [integer!]][system/words/to-pair reduce [value 1]]
		xor-pair: func [p1 p2][to-pair p1/x xor p2/x]
		or-pair: func [p1 p2][to-pair p1/x or p2/x]
		and-pair: func [p1 p2][to-pair p1/x and p2/x]
		remainder-pair: func [val1 val2 /local new][
			val1: either negative? val1/x [abs val1/x + 2147483647.0][val1/x]
			val2: either negative? val2/x [abs val2/x + 2147483647.0][val2/x]
			to-pair to-integer val1 // val2
		]
		floor: func [value][
			value: to-integer either negative? value [value - .999999999999999][value]
			either negative? value [complement value][value]
		]

		hash-v9: func [data [string!] /local nr nr2 byte][
			nr: 1345345333x1
			nr2: 7x1
			foreach byte data [
				if all [byte <> #" " byte <> #"^(tab)"][
					byte: to-pair to-integer byte
					nr: xor-pair nr (((and-pair 63x1 nr) + nr2) * byte) + (nr * 256x1)
					nr2: nr2 + byte
				]
			]
			nr
		]

		hash-v10: func [data [string!] /local nr nr2 adding byte][
			nr: 1345345333x1
			adding: 7x1
			nr2: to-pair to-integer #12345671
			foreach byte data [
				if all [byte <> #" " byte <> #"^(tab)"][
					byte: to-pair to-integer byte
					nr: xor-pair nr (((and-pair 63x1 nr) + adding) * byte) + (nr * 256x1)
					nr2: nr2 + xor-pair nr (nr2 * 256x1)
					adding: adding + byte
				]
			]
			nr: and-pair nr to-pair to-integer #7FFFFFFF
			nr2: and-pair nr2 to-pair to-integer #7FFFFFFF
			reduce [nr nr2]
		]

		crypt-v9: func [data [string!] seed [string!] /local
			new max-value clip-max hp hm nr seed1 seed2 d b i
		][
			new: make string! length? seed
			max-value: to-pair to-integer #01FFFFFF
			clip-max: func [value][remainder-pair value max-value]
			hp: hash-v9 seed
			hm: hash-v9 data	
			nr: clip-max xor-pair hp hm
			seed1: nr
			seed2: nr / 2x1

			foreach i seed [
				seed1: clip-max ((seed1 * 3x1) + seed2)
				seed2: clip-max (seed1 + seed2 + 33x1)
				d: seed1/x / to-decimal max-value/x
				append new to-char floor (d * 31) + 64
			]
			new
		]

		crypt-v10: func [data [string!] seed [string!] /local
			new max-value clip-max pw msg seed1 seed2 d b i
		][
			new: make string! length? seed
			max-value: to-pair to-integer #3FFFFFFF
			clip-max: func [value][remainder-pair value max-value]
			pw: hash-v10 seed
			msg: hash-v10 data	

			seed1: clip-max xor-pair pw/1 msg/1
			seed2: clip-max xor-pair pw/2 msg/2

			foreach i seed [
				seed1: clip-max ((seed1 * 3x1) + seed2)
				seed2: clip-max (seed1 + seed2 + 33x1)
				d: seed1/x / to-decimal max-value/x
				append new to-char floor (d * 31) + 64
			]		
			seed1: clip-max (seed1 * 3x1) + seed2
			seed2: clip-max seed1 + seed2 + 33x0
			d: seed1/x / to-decimal max-value/x
			b: to-char floor (d * 31)

			forall new [new/1: new/1 xor b]
			head new
		]
		
		;--- New 4.1.0+ authentication scheme ---
		crypt-v11: func [data [string!] seed [string!] /local key1 key2][
			key1: checksum/secure data
			key2: checksum/secure key1
			to string! key1 xor checksum/secure join seed key2
		]
		
		scramble: func [data [string!] port [port!] /v10 /local seed][
			if any [none? data empty? data][return ""]
			seed: port/locals/crypt-seed
			if v10 [return crypt-v10 data copy*/part seed 8]
			either port/locals/protocol > 9 [
				either port/locals/auth-v11 [
					crypt-v11 data seed
				][
					crypt-v10 data seed
				]
			][
				crypt-v9 data seed
			]
		]
	]

	scramble: get in scrambler 'scramble
	
;------ Data reading ------

	b0: b1: b2: b3: int: int24: long: string: field: len: byte: s: none
	byte-char: complement charset []
	null: to-char 0
	null-flag: false
	ws: charset " ^-^M^/"

	read-string: [[copy string to null null] | [copy string to end]]
	read-byte: [copy byte byte-char (byte: to integer! to char! :byte)]
	read-int: [
		read-byte (b0: byte)
		read-byte (b1: byte	int: b0 + (256 * b1))
	]
	read-int24: [
		read-byte (b0: byte)
		read-byte (b1: byte)
		read-byte (b2: byte	int24: b0 + (256 * b1) + (65536 * b2))
	]
	read-long: [
		read-byte (b0: byte)
		read-byte (b1: byte)
		read-byte (b2: byte) 
		read-byte (
			b3: byte
			long: to integer! b0 + (256 * b1) + (65536 * b2) + (16777216.0 * b3)
		)
	]
	read-long64: [
		read-long
		skip 4 byte (net-log "Warning: long64 type detected !")
	]
	read-length: [
		#"^(FB)" (len: 0 null-flag: true)
		| #"^(FC)" read-int (len: int)
		| #"^(FD)" read-int24 (len: int24)
		| #"^(FE)" read-long (len: long)
		| read-byte (len: byte)
	]
	read-nbytes: [
		#"^(01)" read-byte (len: byte)
		| #"^(02)" read-int (len: int)
		| #"^(03)" read-int24 (len: int24)
		| #"^(04)" read-long (len: long)
		| none (len: 255)
	]
	read-field: [
		(null-flag: false)
		read-length s: (either null-flag [field: none]
			[field:	copy*/part s len s: skip s len]) :s
	]

	read: func [[throw] port [port!] data [binary!] size [integer!] /local len][
		len: read-io port/sub-port data size 
		if any [zero? len negative? len][
			close* port/sub-port			
			throw throws/closed
		]		
		net-log reform ["low level read of" len "bytes"] 
		len
	]

	defrag-read: func [port [port!] buf [binary!] expected [integer!]][
		clear buf
		while [expected > length? buf][
			read port buf expected - length? buf
		]
	]
	
	read-packet: func [port [port!] /local packet-len pl status][
		pl: port/locals
		pl/stream-end?: false
		
	;--- reading header ---
		defrag-read port pl/buffer std-header-length

		parse/all pl/buffer [
			read-int24  (packet-len: int24)
			read-byte	(pl/seq-num: byte)
		]
	;--- reading data ---
		if packet-len > pl/buf-size [
			net-log reform ["Expanding buffer, old:" pl/buf-size "new:" packet-len]
			tmp: pl/cache
			pl/buffer: make binary! pl/buf-size: packet-len + (length? tmp) + length? pl/buffer
			pl/cache: make binary! pl/cache-size: pl/buf-size
			insert* tail pl/cache tmp
		]
		defrag-read port pl/buffer packet-len
		if packet-len <> length? pl/buffer [
			net-error "Error: inconsistent packet length !"
		]	
		pl/last-status: status: to integer! pl/buffer/1
		pl/error-code: pl/error-msg: none
		
		if status = 255 [
			parse/all next pl/buffer either any [none? pl/protocol pl/protocol > 9][
				[	read-int 	(pl/error-code: int)
					read-string (pl/error-msg: string)]
			][
				pl/error-code: 0
				[	read-string (pl/error-msg: string)]
			]
			pl/stream-end?: true			
			net-error reform ["ERROR" any [pl/error-code ""]":" pl/error-msg]
		]
		if all [status = 254 packet-len = 1][pl/stream-end?: true]
		pl/buffer
	]
	
	read-packet-via: func [port [port!] /local pl tmp][
		pl: port/locals
		if empty? pl/cache [
			read-packet port
			if pl/stream-end? [return #{}]	; empty set !
		]
		tmp: pl/cache			; swap cache<=>buffer		
		pl/cache: pl/buffer
		pl/buffer: :tmp
		
		tmp: pl/cache-size
		pl/cache-size: pl/buf-size
		pl/buf-size: :tmp
		
		read-packet port
		pl/cache
	]
	
	read-columns-number: func [port [port!] /local colnb][
		parse/all/case read-packet port [
			read-length (if zero? colnb: len [port/locals/stream-end?: true])
			read-length	(port/locals/matched-rows: len)
			read-length 
		]
		if not zero? colnb [port/locals/matched-rows: none]
		colnb
	]
	
	read-columns-headers: func [port [port!] cols [integer!] /local pl col][
		pl: port/locals
		pl/columns: make block! cols
		loop cols [
			col: make column-class []
			parse/all/case read-packet port [
				read-field	(col/table:	field)
				read-field	(col/name: 	field)
				read-nbytes	(col/length: len)
				read-nbytes	(col/type: decode/type len)
				read-field	(
					col/flags: decode/flags to integer! field/1 
					col/decimals: to integer! field/2 
				)
			]
			append pl/columns :col
		]
		read-packet	port			; check the ending flag
		if not pl/stream-end? [
			flush-pending-data port
			net-error "Error: end of columns stream not found"
		]
		pl/stream-end?: false		; prepare correct state for 
		clear pl/cache				; rows reading.
	]

	read-rows: func [port [port!] /part n [integer!]
		/local pl row-data row rows cols count
	][
		pl: port/locals
		rows: make block! max any [n 0] pl/rows
		cols: length? pl/columns
		count: 0
		forever [
			row-data: read-packet-via port
			if empty? row-data [return rows]		; empty set
			row: make block! cols
			parse/all/case row-data [any [read-field (append row field)]]
			either pl/flat? [
				insert* tail rows row
			][
				insert*/only tail rows row
			]
			if pl/stream-end? or all [part n = count: count + 1][break]	; end of stream or rows # reached
		]
		if pl/auto-conv? [convert-types port rows]
		if pl/newlines? [
			either pl/flat? [
				new-line/skip rows true cols
			][
				new-line/all rows true
			]
		]
		rows
	]
	
	read-cmd: func [port [port!] cmd [integer!] /local res][
		either cmd = defs/cmd/statistics [
			to-string read-packet port
		][
			res: read-packet port
			either all [cmd = defs/cmd/ping zero? port/locals/last-status][true][none]
		]
	]
	
	flush-pending-data: func [port [port!] /local pl len][
		pl: port/locals
		if not pl/stream-end? [
			net-log "flushing unread data..."
			until [
				clear pl/buffer
				len: read port pl/buffer pl/buf-size			
				all [pl/buf-size > len end-marker = last pl/buffer]
			]
			net-log "flush end."
			pl/stream-end?: true
		]
	]

;------ Data sending ------

	write-byte: func [value [integer!]][to char! value]
	
	write-int: func [value [integer!]][
		join to char! value // 256 to char! value / 256
	]

	write-int24: func [value [integer!]][
		join to char! value // 256 [
			to char! (to integer! value / 256) and 255
			to char! (to integer! value / 65536) and 255
		]
	]

	write-long: func [value [integer!]][
		join to char! value // 256 [
			to char! (to integer! value / 256) and 255
			to char! (to integer! value / 65536) and 255
			to char! (to integer! value / 16777216) and 255
		]
	]

	write-string: func [value [string!]][
		join value to char! 0
	]

	send-packet: func [port [port!] data [string!]][
		data: to-binary rejoin [
			write-int24 length? data
			write-byte port/locals/seq-num: port/locals/seq-num + 1
			data
		]
		write-io port/sub-port data length? data
		port/locals/stream-end?: false
	]

	send-cmd: func [port [port!] cmd [integer!] cmd-data] compose/deep [
		port/locals/seq-num: -1
		send-packet port rejoin [
			write-byte cmd
			switch/default cmd [
				(defs/cmd/quit)			[""]
				(defs/cmd/shutdown)		[""]
				(defs/cmd/statistics)	[""]
				(defs/cmd/debug)		[""]
				(defs/cmd/ping)			[""]
				(defs/cmd/reload)		[write-byte encode-refresh cmd-data]
				(defs/cmd/process-kill)	[write-long pick* cmd-data 1]
				(defs/cmd/change-user)	[
					rejoin [
						write-string pick* cmd-data 1
						write-string scramble pick* cmd-data 2 port
						write-string pick* cmd-data 3
					]
				]
			][either string? cmd-data [cmd-data][pick* cmd-data 1]]
		]
	]
	
	insert-query: func [port [port!] data [string! block!] /local colnb][
		net-log data
		send-cmd port defs/cmd/query data
		colnb: read-columns-number port
		if not any [zero? colnb port/locals/stream-end?][
			read-columns-headers port colnb
		]
		none
	]
	
	insert-all-queries: func [port [port!] data [string!] /local s e res][
		parse/all s: data [
			any [
				#"#" thru newline
				| #"'" any ["\'" | "''" | not-squote] #"'"
				|{"} any [{\"} | {""} | not-dquote] {"}
				| #"`" thru #"`"
				| e: #";" (
					clear sql-buffer
					insert*/part sql-buffer s e
					res: insert-query port sql-buffer
				  ) any [ws] s:
				| skip
			]
		]
		if not tail? s [res: insert-query port s]
		res
	]

	insert-cmd: func [port [port!] data [block!] /local type res][
		type: select defs/cmd data/1
		either type [
			send-cmd port type next data
			res: read-cmd port type			
			port/locals/stream-end?: true
			res
		][
			port/locals/stream-end?: true
			net-error reform ["Unknown command" data/1]
		]
	]
	
	try-reconnect: func [port [port!]][
		net-log "Connection closed by server! Reconnecting..."
		if throws/closed = catch [open port][net-error "Server down!"]
	]
	
	check-opened: func [port [port!]][	
		if not zero? port/sub-port/state/flags and 1024 [
			port/state/flags: 1024
			try-reconnect port
		]
	]
	
	do-handshake: func [port [port!] /local pl client-param auth-pack key err data][
		either pl: port/locals [
			clear pl/cache
			clear pl/buffer
			pl/seq-num: 0
			pl/last-status:
			pl/stream-end?: none
		][
			pl: port/locals: make locals-class []
			pl/buffer: make binary! pl/buf-size
			pl/cache: make binary! pl/buf-size
			pl/conv-list: copy*/deep conv-model
		]

		parse/all read-packet port [
			read-byte 	(pl/protocol: byte)
			read-string (pl/version: string)
			read-long 	(pl/thread-id: long)
			read-string	(pl/crypt-seed: string)
			read-int	(pl/capabilities: int)
			read-byte	(pl/character-set: byte)
			read-int	(pl/server-status: int) 
			read-int	(pl/capabilities: (shift/left int 16) or pl/capabilities)
			read-byte	(pl/seed-length: byte)
			10 skip		; reserved for future use
			read-string	(
				if string [
					pl/crypt-seed: join copy* pl/crypt-seed string
					pl/auth-v11: yes
				]
			)
			to end		; skipping data for pre4.1.x protocols
		]

		if pl/protocol = -1 [
			close* port/sub-port
			net-error "Server configuration denies access to locals source^/Port closed!"
		]

		show-server pl

		feature-supported?: func ['feature] [
			(select defs/client feature) and pl/capabilities
		]

		client-param: defs/client/found-rows or defs/client/connect-with-db
		client-param: either pl/protocol > 9 [
			client-param 
			or feature-supported? long-password 
			or feature-supported? transactions 
			or feature-supported? protocol-41
			or feature-supported? secure-connection
			or feature-supported? multi-queries
			or feature-supported? multi-results
		][
			client-param and complement defs/client/long-password
		]
		auth-pack: either pl/protocol > 9 [
			rejoin [
				write-long client-param
				;write-long (length? port/user) + (length? port/pass)
				;	+ 7 + std-header-length
				write-long to integer! #1000000 ;max packet length, the value 16M is from mysql.exe
				write-byte pl/character-set
				head change/dup "" to char! 0 23; 23 0's
				write-string port/user
				write-byte 20
				write-string rejoin [(key: scramble port/pass port) any [port/path ""] ]
			]
		][
			rejoin [
				write-long client-param
				write-long (length? port/user) + (length? port/pass)
					+ 7 + std-header-length
				write-string port/user
				write-string key: scramble port/pass port
				write-string any [port/path ""]
			]
		]
		send-packet port auth-pack
	
		either error? set/any 'err try [data: read-packet port][
			any [all [find key #{00} pl/error-code] err]	; -- detect the flaw in the protocol
		][
			if all [1 = length? data data/1 = #"^(FE)"][
				net-log "Switching to old password mode!"
				send-packet port write-string scramble/v10 port/pass port
				read-packet port		
			]
			net-log "Connected to server. Handshake OK"
			none
		]
	]
	
;------ Public interface ------

	init: func [port [port!] spec /local scheme args][
		if url? spec [net-utils/url-parser/parse-url port spec] 
		scheme: port/scheme 
		port/url: spec 
		if none? port/host [
			net-error reform ["No network server for" scheme "is specified"]
		] 
		if none? port/port-id [
			net-error reform ["No port address for" scheme "is specified"]
		]
		if all [none? port/path port/target][
			port/path: port/target
			port/target: none
		]
		if all [port/path slash = last port/path][
			remove back tail port/path
		]
		if none? port/user [port/user: make string! 0]
		if none? port/pass [port/pass: make string! 0]
		if port/pass = "?" [port/pass: ask/hide "Password: "]
	]

	open: func [port [port!] /local retry q sql][	
		retry: 10
		until [
			open-proto port   
			set-modes* port/sub-port [keep-alive: true]
			port/sub-port/state/flags: 524835	; force /direct/binary mode
			retry: retry - 1
			if res: do-handshake port [close* port/sub-port]
			any [none? res zero? retry]
		]
		if zero? retry [net-error "Cannot handshake with server"]
		port/locals/stream-end?: true	; force stream-end, so 'copy won't timeout !
		if zero? port/state/flags and 2 [
			either sql: port/state/custom [
				if not string? sql: first sql [net-error "invalid query"]
				insert port sql
			][
				insert port either port/target [
					join "DESC " port/target
				][
					port/locals/flat?: on
					join "SHOW " pick* ["DATABASES" "TABLES"] not port/path
				]
			]
		]
		port/state/tail: 10		; for 'pick to work properly
		if q: port/locals/init [
			net-log ["Sending init string :" q]
			insert port q
		]
	]

	close: func [port [port!]][
		port/sub-port/timeout: 4
		either error? try [
			flush-pending-data port
			send-cmd port defs/cmd/quit []
		][net-log "Error on closing port!"][net-log "Close ok."]
		port/state/flags: 1024
		close* port/sub-port
	]
	
	insert: func [[throw] port [port!] data [string! block!] /local res][
		check-opened port
		flush-pending-data port
		port/locals/columns: none
		if all [port/locals/auto-ping? data <> [ping]][
			net-log "sending ping..."
			res: catch [insert-cmd port [ping]]
			if any [res = throws/closed not res][try-reconnect port]
		]
		if throws/closed = catch [
			if all [string? data data/1 = #"["][data: load data]
			res: either block? data [
				if empty? data [net-error "No data!"]
				either string? data/1 [
					insert-query port map-rebol-values data
				][
					insert-cmd port data
				]
			][
				insert-all-queries port data
			]
		][net-error  "Connection lost - Port closed!"]
		res
	]
	
	pick: func [port [port!] data][
		either any [none? data data = 1][
			either port/locals/stream-end? [copy* []][copy/part port 1]
		][none]
	]

	copy: func [port /part data [integer!]][
		check-opened port
		either not port/locals/stream-end? [
			either all [value? 'part part][read-rows/part port data]
				[read-rows port]
		][none]
	]
	
	set 'send-sql func [
		[throw catch]
		db [port!] data [string! block!]
		/flat /raw /named /local result pl
	][
		pl: db/locals
		pl/flat?: to logic! flat
		pl/auto-conv?: not to logic! raw
		result: any [
			insert db data
			copy db
		]
		if flat [pl/flat?: off]
		if raw  [pl/auto-conv?: on]
		either all [named block? result not empty? result][
			either flat [
				if greater? length? result length? pl/columns [
					make error! "/flat and /named not allowed in this case!"
				]
				name-fields db result
			][
				forall result [change/only result name-fields db first result]
				head result
			]
		][
			result
		]
	]
	
	set 'name-fields func [db [port!] record [block!] /local out cols][
		out: make block! 2 * length? record
		cols: db/locals/columns
		repeat n length? record [
			insert* tail out to word! cols/:n/name
			insert* tail out record/:n
		]
		out
	]

	;--- Register ourselves. 
	net-utils/net-install MySQL self 3306
]
