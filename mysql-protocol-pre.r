REBOL [
	Title: "MySQL Protocol"
	Authors: ["Nenad Rakocevic / SOFTINNOV" "Shixin Zeng <szeng@atronixengineering.com>"]
	Email: mysql@softinnov.com
	Web: http://softinnov.org/rebol/mysql.shtml
	Date: <DATE>
	File: %mysql-protocol.r
	Version: 1.3.1
	Purpose: "MySQL Driver for REBOL"
	GIT-COMMIT: "<GIT-COMMIT-ID>"
]
mysql-errors: [
;imported from mysqld_error.h in libmysqclient
	ER_ERROR_FIRST 1000
	ER_HASHCHK 1000
	ER_NISAMCHK 1001
	ER_NO 1002
	ER_YES 1003
	ER_CANT_CREATE_FILE 1004
	ER_CANT_CREATE_TABLE 1005
	ER_CANT_CREATE_DB 1006
	ER_DB_CREATE_EXISTS 1007
	ER_DB_DROP_EXISTS 1008
	ER_DB_DROP_DELETE 1009
	ER_DB_DROP_RMDIR 1010
	ER_CANT_DELETE_FILE 1011
	ER_CANT_FIND_SYSTEM_REC 1012
	ER_CANT_GET_STAT 1013
	ER_CANT_GET_WD 1014
	ER_CANT_LOCK 1015
	ER_CANT_OPEN_FILE 1016
	ER_FILE_NOT_FOUND 1017
	ER_CANT_READ_DIR 1018
	ER_CANT_SET_WD 1019
	ER_CHECKREAD 1020
	ER_DISK_FULL 1021
	ER_DUP_KEY 1022
	ER_ERROR_ON_CLOSE 1023
	ER_ERROR_ON_READ 1024
	ER_ERROR_ON_RENAME 1025
	ER_ERROR_ON_WRITE 1026
	ER_FILE_USED 1027
	ER_FILSORT_ABORT 1028
	ER_FORM_NOT_FOUND 1029
	ER_GET_ERRNO 1030
	ER_ILLEGAL_HA 1031
	ER_KEY_NOT_FOUND 1032
	ER_NOT_FORM_FILE 1033
	ER_NOT_KEYFILE 1034
	ER_OLD_KEYFILE 1035
	ER_OPEN_AS_READONLY 1036
	ER_OUTOFMEMORY 1037
	ER_OUT_OF_SORTMEMORY 1038
	ER_UNEXPECTED_EOF 1039
	ER_CON_COUNT_ERROR 1040
	ER_OUT_OF_RESOURCES 1041
	ER_BAD_HOST_ERROR 1042
	ER_HANDSHAKE_ERROR 1043
	ER_DBACCESS_DENIED_ERROR 1044
	ER_ACCESS_DENIED_ERROR 1045
	ER_NO_DB_ERROR 1046
	ER_UNKNOWN_COM_ERROR 1047
	ER_BAD_NULL_ERROR 1048
	ER_BAD_DB_ERROR 1049
	ER_TABLE_EXISTS_ERROR 1050
	ER_BAD_TABLE_ERROR 1051
	ER_NON_UNIQ_ERROR 1052
	ER_SERVER_SHUTDOWN 1053
	ER_BAD_FIELD_ERROR 1054
	ER_WRONG_FIELD_WITH_GROUP 1055
	ER_WRONG_GROUP_FIELD 1056
	ER_WRONG_SUM_SELECT 1057
	ER_WRONG_VALUE_COUNT 1058
	ER_TOO_LONG_IDENT 1059
	ER_DUP_FIELDNAME 1060
	ER_DUP_KEYNAME 1061
	ER_DUP_ENTRY 1062
	ER_WRONG_FIELD_SPEC 1063
	ER_PARSE_ERROR 1064
	ER_EMPTY_QUERY 1065
	ER_NONUNIQ_TABLE 1066
	ER_INVALID_DEFAULT 1067
	ER_MULTIPLE_PRI_KEY 1068
	ER_TOO_MANY_KEYS 1069
	ER_TOO_MANY_KEY_PARTS 1070
	ER_TOO_LONG_KEY 1071
	ER_KEY_COLUMN_DOES_NOT_EXITS 1072
	ER_BLOB_USED_AS_KEY 1073
	ER_TOO_BIG_FIELDLENGTH 1074
	ER_WRONG_AUTO_KEY 1075
	ER_READY 1076
	ER_NORMAL_SHUTDOWN 1077
	ER_GOT_SIGNAL 1078
	ER_SHUTDOWN_COMPLETE 1079
	ER_FORCING_CLOSE 1080
	ER_IPSOCK_ERROR 1081
	ER_NO_SUCH_INDEX 1082
	ER_WRONG_FIELD_TERMINATORS 1083
	ER_BLOBS_AND_NO_TERMINATED 1084
	ER_TEXTFILE_NOT_READABLE 1085
	ER_FILE_EXISTS_ERROR 1086
	ER_LOAD_INFO 1087
	ER_ALTER_INFO 1088
	ER_WRONG_SUB_KEY 1089
	ER_CANT_REMOVE_ALL_FIELDS 1090
	ER_CANT_DROP_FIELD_OR_KEY 1091
	ER_INSERT_INFO 1092
	ER_UPDATE_TABLE_USED 1093
	ER_NO_SUCH_THREAD 1094
	ER_KILL_DENIED_ERROR 1095
	ER_NO_TABLES_USED 1096
	ER_TOO_BIG_SET 1097
	ER_NO_UNIQUE_LOGFILE 1098
	ER_TABLE_NOT_LOCKED_FOR_WRITE 1099
	ER_TABLE_NOT_LOCKED 1100
	ER_BLOB_CANT_HAVE_DEFAULT 1101
	ER_WRONG_DB_NAME 1102
	ER_WRONG_TABLE_NAME 1103
	ER_TOO_BIG_SELECT 1104
	ER_UNKNOWN_ERROR 1105
	ER_UNKNOWN_PROCEDURE 1106
	ER_WRONG_PARAMCOUNT_TO_PROCEDURE 1107
	ER_WRONG_PARAMETERS_TO_PROCEDURE 1108
	ER_UNKNOWN_TABLE 1109
	ER_FIELD_SPECIFIED_TWICE 1110
	ER_INVALID_GROUP_FUNC_USE 1111
	ER_UNSUPPORTED_EXTENSION 1112
	ER_TABLE_MUST_HAVE_COLUMNS 1113
	ER_RECORD_FILE_FULL 1114
	ER_UNKNOWN_CHARACTER_SET 1115
	ER_TOO_MANY_TABLES 1116
	ER_TOO_MANY_FIELDS 1117
	ER_TOO_BIG_ROWSIZE 1118
	ER_STACK_OVERRUN 1119
	ER_WRONG_OUTER_JOIN 1120
	ER_NULL_COLUMN_IN_INDEX 1121
	ER_CANT_FIND_UDF 1122
	ER_CANT_INITIALIZE_UDF 1123
	ER_UDF_NO_PATHS 1124
	ER_UDF_EXISTS 1125
	ER_CANT_OPEN_LIBRARY 1126
	ER_CANT_FIND_DL_ENTRY 1127
	ER_FUNCTION_NOT_DEFINED 1128
	ER_HOST_IS_BLOCKED 1129
	ER_HOST_NOT_PRIVILEGED 1130
	ER_PASSWORD_ANONYMOUS_USER 1131
	ER_PASSWORD_NOT_ALLOWED 1132
	ER_PASSWORD_NO_MATCH 1133
	ER_UPDATE_INFO 1134
	ER_CANT_CREATE_THREAD 1135
	ER_WRONG_VALUE_COUNT_ON_ROW 1136
	ER_CANT_REOPEN_TABLE 1137
	ER_INVALID_USE_OF_NULL 1138
	ER_REGEXP_ERROR 1139
	ER_MIX_OF_GROUP_FUNC_AND_FIELDS 1140
	ER_NONEXISTING_GRANT 1141
	ER_TABLEACCESS_DENIED_ERROR 1142
	ER_COLUMNACCESS_DENIED_ERROR 1143
	ER_ILLEGAL_GRANT_FOR_TABLE 1144
	ER_GRANT_WRONG_HOST_OR_USER 1145
	ER_NO_SUCH_TABLE 1146
	ER_NONEXISTING_TABLE_GRANT 1147
	ER_NOT_ALLOWED_COMMAND 1148
	ER_SYNTAX_ERROR 1149
	ER_DELAYED_CANT_CHANGE_LOCK 1150
	ER_TOO_MANY_DELAYED_THREADS 1151
	ER_ABORTING_CONNECTION 1152
	ER_NET_PACKET_TOO_LARGE 1153
	ER_NET_READ_ERROR_FROM_PIPE 1154
	ER_NET_FCNTL_ERROR 1155
	ER_NET_PACKETS_OUT_OF_ORDER 1156
	ER_NET_UNCOMPRESS_ERROR 1157
	ER_NET_READ_ERROR 1158
	ER_NET_READ_INTERRUPTED 1159
	ER_NET_ERROR_ON_WRITE 1160
	ER_NET_WRITE_INTERRUPTED 1161
	ER_TOO_LONG_STRING 1162
	ER_TABLE_CANT_HANDLE_BLOB 1163
	ER_TABLE_CANT_HANDLE_AUTO_INCREMENT 1164
	ER_DELAYED_INSERT_TABLE_LOCKED 1165
	ER_WRONG_COLUMN_NAME 1166
	ER_WRONG_KEY_COLUMN 1167
	ER_WRONG_MRG_TABLE 1168
	ER_DUP_UNIQUE 1169
	ER_BLOB_KEY_WITHOUT_LENGTH 1170
	ER_PRIMARY_CANT_HAVE_NULL 1171
	ER_TOO_MANY_ROWS 1172
	ER_REQUIRES_PRIMARY_KEY 1173
	ER_NO_RAID_COMPILED 1174
	ER_UPDATE_WITHOUT_KEY_IN_SAFE_MODE 1175
	ER_KEY_DOES_NOT_EXITS 1176
	ER_CHECK_NO_SUCH_TABLE 1177
	ER_CHECK_NOT_IMPLEMENTED 1178
	ER_CANT_DO_THIS_DURING_AN_TRANSACTION 1179
	ER_ERROR_DURING_COMMIT 1180
	ER_ERROR_DURING_ROLLBACK 1181
	ER_ERROR_DURING_FLUSH_LOGS 1182
	ER_ERROR_DURING_CHECKPOINT 1183
	ER_NEW_ABORTING_CONNECTION 1184
	ER_DUMP_NOT_IMPLEMENTED 1185
	ER_FLUSH_MASTER_BINLOG_CLOSED 1186
	ER_INDEX_REBUILD 1187
	ER_MASTER 1188
	ER_MASTER_NET_READ 1189
	ER_MASTER_NET_WRITE 1190
	ER_FT_MATCHING_KEY_NOT_FOUND 1191
	ER_LOCK_OR_ACTIVE_TRANSACTION 1192
	ER_UNKNOWN_SYSTEM_VARIABLE 1193
	ER_CRASHED_ON_USAGE 1194
	ER_CRASHED_ON_REPAIR 1195
	ER_WARNING_NOT_COMPLETE_ROLLBACK 1196
	ER_TRANS_CACHE_FULL 1197
	ER_SLAVE_MUST_STOP 1198
	ER_SLAVE_NOT_RUNNING 1199
	ER_BAD_SLAVE 1200
	ER_MASTER_INFO 1201
	ER_SLAVE_THREAD 1202
	ER_TOO_MANY_USER_CONNECTIONS 1203
	ER_SET_CONSTANTS_ONLY 1204
	ER_LOCK_WAIT_TIMEOUT 1205
	ER_LOCK_TABLE_FULL 1206
	ER_READ_ONLY_TRANSACTION 1207
	ER_DROP_DB_WITH_READ_LOCK 1208
	ER_CREATE_DB_WITH_READ_LOCK 1209
	ER_WRONG_ARGUMENTS 1210
	ER_NO_PERMISSION_TO_CREATE_USER 1211
	ER_UNION_TABLES_IN_DIFFERENT_DIR 1212
	ER_LOCK_DEADLOCK 1213
	ER_TABLE_CANT_HANDLE_FT 1214
	ER_CANNOT_ADD_FOREIGN 1215
	ER_NO_REFERENCED_ROW 1216
	ER_ROW_IS_REFERENCED 1217
	ER_CONNECT_TO_MASTER 1218
	ER_QUERY_ON_MASTER 1219
	ER_ERROR_WHEN_EXECUTING_COMMAND 1220
	ER_WRONG_USAGE 1221
	ER_WRONG_NUMBER_OF_COLUMNS_IN_SELECT 1222
	ER_CANT_UPDATE_WITH_READLOCK 1223
	ER_MIXING_NOT_ALLOWED 1224
	ER_DUP_ARGUMENT 1225
	ER_USER_LIMIT_REACHED 1226
	ER_SPECIFIC_ACCESS_DENIED_ERROR 1227
	ER_LOCAL_VARIABLE 1228
	ER_GLOBAL_VARIABLE 1229
	ER_NO_DEFAULT 1230
	ER_WRONG_VALUE_FOR_VAR 1231
	ER_WRONG_TYPE_FOR_VAR 1232
	ER_VAR_CANT_BE_READ 1233
	ER_CANT_USE_OPTION_HERE 1234
	ER_NOT_SUPPORTED_YET 1235
	ER_MASTER_FATAL_ERROR_READING_BINLOG 1236
	ER_SLAVE_IGNORED_TABLE 1237
	ER_INCORRECT_GLOBAL_LOCAL_VAR 1238
	ER_WRONG_FK_DEF 1239
	ER_KEY_REF_DO_NOT_MATCH_TABLE_REF 1240
	ER_OPERAND_COLUMNS 1241
	ER_SUBQUERY_NO_1_ROW 1242
	ER_UNKNOWN_STMT_HANDLER 1243
	ER_CORRUPT_HELP_DB 1244
	ER_CYCLIC_REFERENCE 1245
	ER_AUTO_CONVERT 1246
	ER_ILLEGAL_REFERENCE 1247
	ER_DERIVED_MUST_HAVE_ALIAS 1248
	ER_SELECT_REDUCED 1249
	ER_TABLENAME_NOT_ALLOWED_HERE 1250
	ER_NOT_SUPPORTED_AUTH_MODE 1251
	ER_SPATIAL_CANT_HAVE_NULL 1252
	ER_COLLATION_CHARSET_MISMATCH 1253
	ER_SLAVE_WAS_RUNNING 1254
	ER_SLAVE_WAS_NOT_RUNNING 1255
	ER_TOO_BIG_FOR_UNCOMPRESS 1256
	ER_ZLIB_Z_MEM_ERROR 1257
	ER_ZLIB_Z_BUF_ERROR 1258
	ER_ZLIB_Z_DATA_ERROR 1259
	ER_CUT_VALUE_GROUP_CONCAT 1260
	ER_WARN_TOO_FEW_RECORDS 1261
	ER_WARN_TOO_MANY_RECORDS 1262
	ER_WARN_NULL_TO_NOTNULL 1263
	ER_WARN_DATA_OUT_OF_RANGE 1264
	WARN_DATA_TRUNCATED 1265
	ER_WARN_USING_OTHER_HANDLER 1266
	ER_CANT_AGGREGATE_2COLLATIONS 1267
	ER_DROP_USER 1268
	ER_REVOKE_GRANTS 1269
	ER_CANT_AGGREGATE_3COLLATIONS 1270
	ER_CANT_AGGREGATE_NCOLLATIONS 1271
	ER_VARIABLE_IS_NOT_STRUCT 1272
	ER_UNKNOWN_COLLATION 1273
	ER_SLAVE_IGNORED_SSL_PARAMS 1274
	ER_SERVER_IS_IN_SECURE_AUTH_MODE 1275
	ER_WARN_FIELD_RESOLVED 1276
	ER_BAD_SLAVE_UNTIL_COND 1277
	ER_MISSING_SKIP_SLAVE 1278
	ER_UNTIL_COND_IGNORED 1279
	ER_WRONG_NAME_FOR_INDEX 1280
	ER_WRONG_NAME_FOR_CATALOG 1281
	ER_WARN_QC_RESIZE 1282
	ER_BAD_FT_COLUMN 1283
	ER_UNKNOWN_KEY_CACHE 1284
	ER_WARN_HOSTNAME_WONT_WORK 1285
	ER_UNKNOWN_STORAGE_ENGINE 1286
	ER_WARN_DEPRECATED_SYNTAX 1287
	ER_NON_UPDATABLE_TABLE 1288
	ER_FEATURE_DISABLED 1289
	ER_OPTION_PREVENTS_STATEMENT 1290
	ER_DUPLICATED_VALUE_IN_TYPE 1291
	ER_TRUNCATED_WRONG_VALUE 1292
	ER_TOO_MUCH_AUTO_TIMESTAMP_COLS 1293
	ER_INVALID_ON_UPDATE 1294
	ER_UNSUPPORTED_PS 1295
	ER_GET_ERRMSG 1296
	ER_GET_TEMPORARY_ERRMSG 1297
	ER_UNKNOWN_TIME_ZONE 1298
	ER_WARN_INVALID_TIMESTAMP 1299
	ER_INVALID_CHARACTER_STRING 1300
	ER_WARN_ALLOWED_PACKET_OVERFLOWED 1301
	ER_CONFLICTING_DECLARATIONS 1302
	ER_SP_NO_RECURSIVE_CREATE 1303
	ER_SP_ALREADY_EXISTS 1304
	ER_SP_DOES_NOT_EXIST 1305
	ER_SP_DROP_FAILED 1306
	ER_SP_STORE_FAILED 1307
	ER_SP_LILABEL_MISMATCH 1308
	ER_SP_LABEL_REDEFINE 1309
	ER_SP_LABEL_MISMATCH 1310
	ER_SP_UNINIT_VAR 1311
	ER_SP_BADSELECT 1312
	ER_SP_BADRETURN 1313
	ER_SP_BADSTATEMENT 1314
	ER_UPDATE_LOG_DEPRECATED_IGNORED 1315
	ER_UPDATE_LOG_DEPRECATED_TRANSLATED 1316
	ER_QUERY_INTERRUPTED 1317
	ER_SP_WRONG_NO_OF_ARGS 1318
	ER_SP_COND_MISMATCH 1319
	ER_SP_NORETURN 1320
	ER_SP_NORETURNEND 1321
	ER_SP_BAD_CURSOR_QUERY 1322
	ER_SP_BAD_CURSOR_SELECT 1323
	ER_SP_CURSOR_MISMATCH 1324
	ER_SP_CURSOR_ALREADY_OPEN 1325
	ER_SP_CURSOR_NOT_OPEN 1326
	ER_SP_UNDECLARED_VAR 1327
	ER_SP_WRONG_NO_OF_FETCH_ARGS 1328
	ER_SP_FETCH_NO_DATA 1329
	ER_SP_DUP_PARAM 1330
	ER_SP_DUP_VAR 1331
	ER_SP_DUP_COND 1332
	ER_SP_DUP_CURS 1333
	ER_SP_CANT_ALTER 1334
	ER_SP_SUBSELECT_NYI 1335
	ER_STMT_NOT_ALLOWED_IN_SF_OR_TRG 1336
	ER_SP_VARCOND_AFTER_CURSHNDLR 1337
	ER_SP_CURSOR_AFTER_HANDLER 1338
	ER_SP_CASE_NOT_FOUND 1339
	ER_FPARSER_TOO_BIG_FILE 1340
	ER_FPARSER_BAD_HEADER 1341
	ER_FPARSER_EOF_IN_COMMENT 1342
	ER_FPARSER_ERROR_IN_PARAMETER 1343
	ER_FPARSER_EOF_IN_UNKNOWN_PARAMETER 1344
	ER_VIEW_NO_EXPLAIN 1345
	ER_FRM_UNKNOWN_TYPE 1346
	ER_WRONG_OBJECT 1347
	ER_NONUPDATEABLE_COLUMN 1348
	ER_VIEW_SELECT_DERIVED 1349
	ER_VIEW_SELECT_CLAUSE 1350
	ER_VIEW_SELECT_VARIABLE 1351
	ER_VIEW_SELECT_TMPTABLE 1352
	ER_VIEW_WRONG_LIST 1353
	ER_WARN_VIEW_MERGE 1354
	ER_WARN_VIEW_WITHOUT_KEY 1355
	ER_VIEW_INVALID 1356
	ER_SP_NO_DROP_SP 1357
	ER_SP_GOTO_IN_HNDLR 1358
	ER_TRG_ALREADY_EXISTS 1359
	ER_TRG_DOES_NOT_EXIST 1360
	ER_TRG_ON_VIEW_OR_TEMP_TABLE 1361
	ER_TRG_CANT_CHANGE_ROW 1362
	ER_TRG_NO_SUCH_ROW_IN_TRG 1363
	ER_NO_DEFAULT_FOR_FIELD 1364
	ER_DIVISION_BY_ZERO 1365
	ER_TRUNCATED_WRONG_VALUE_FOR_FIELD 1366
	ER_ILLEGAL_VALUE_FOR_TYPE 1367
	ER_VIEW_NONUPD_CHECK 1368
	ER_VIEW_CHECK_FAILED 1369
	ER_PROCACCESS_DENIED_ERROR 1370
	ER_RELAY_LOG_FAIL 1371
	ER_PASSWD_LENGTH 1372
	ER_UNKNOWN_TARGET_BINLOG 1373
	ER_IO_ERR_LOG_INDEX_READ 1374
	ER_BINLOG_PURGE_PROHIBITED 1375
	ER_FSEEK_FAIL 1376
	ER_BINLOG_PURGE_FATAL_ERR 1377
	ER_LOG_IN_USE 1378
	ER_LOG_PURGE_UNKNOWN_ERR 1379
	ER_RELAY_LOG_INIT 1380
	ER_NO_BINARY_LOGGING 1381
	ER_RESERVED_SYNTAX 1382
	ER_WSAS_FAILED 1383
	ER_DIFF_GROUPS_PROC 1384
	ER_NO_GROUP_FOR_PROC 1385
	ER_ORDER_WITH_PROC 1386
	ER_LOGGING_PROHIBIT_CHANGING_OF 1387
	ER_NO_FILE_MAPPING 1388
	ER_WRONG_MAGIC 1389
	ER_PS_MANY_PARAM 1390
	ER_KEY_PART_0 1391
	ER_VIEW_CHECKSUM 1392
	ER_VIEW_MULTIUPDATE 1393
	ER_VIEW_NO_INSERT_FIELD_LIST 1394
	ER_VIEW_DELETE_MERGE_VIEW 1395
	ER_CANNOT_USER 1396
	ER_XAER_NOTA 1397
	ER_XAER_INVAL 1398
	ER_XAER_RMFAIL 1399
	ER_XAER_OUTSIDE 1400
	ER_XAER_RMERR 1401
	ER_XA_RBROLLBACK 1402
	ER_NONEXISTING_PROC_GRANT 1403
	ER_PROC_AUTO_GRANT_FAIL 1404
	ER_PROC_AUTO_REVOKE_FAIL 1405
	ER_DATA_TOO_LONG 1406
	ER_SP_BAD_SQLSTATE 1407
	ER_STARTUP 1408
	ER_LOAD_FROM_FIXED_SIZE_ROWS_TO_VAR 1409
	ER_CANT_CREATE_USER_WITH_GRANT 1410
	ER_WRONG_VALUE_FOR_TYPE 1411
	ER_TABLE_DEF_CHANGED 1412
	ER_SP_DUP_HANDLER 1413
	ER_SP_NOT_VAR_ARG 1414
	ER_SP_NO_RETSET 1415
	ER_CANT_CREATE_GEOMETRY_OBJECT 1416
	ER_FAILED_ROUTINE_BREAK_BINLOG 1417
	ER_BINLOG_UNSAFE_ROUTINE 1418
	ER_BINLOG_CREATE_ROUTINE_NEED_SUPER 1419
	ER_EXEC_STMT_WITH_OPEN_CURSOR 1420
	ER_STMT_HAS_NO_OPEN_CURSOR 1421
	ER_COMMIT_NOT_ALLOWED_IN_SF_OR_TRG 1422
	ER_NO_DEFAULT_FOR_VIEW_FIELD 1423
	ER_SP_NO_RECURSION 1424
	ER_TOO_BIG_SCALE 1425
	ER_TOO_BIG_PRECISION 1426
	ER_M_BIGGER_THAN_D 1427
	ER_WRONG_LOCK_OF_SYSTEM_TABLE 1428
	ER_CONNECT_TO_FOREIGN_DATA_SOURCE 1429
	ER_QUERY_ON_FOREIGN_DATA_SOURCE 1430
	ER_FOREIGN_DATA_SOURCE_DOESNT_EXIST 1431
	ER_FOREIGN_DATA_STRING_INVALID_CANT_CREATE 1432
	ER_FOREIGN_DATA_STRING_INVALID 1433
	ER_CANT_CREATE_FEDERATED_TABLE 1434
	ER_TRG_IN_WRONG_SCHEMA 1435
	ER_STACK_OVERRUN_NEED_MORE 1436
	ER_TOO_LONG_BODY 1437
	ER_WARN_CANT_DROP_DEFAULT_KEYCACHE 1438
	ER_TOO_BIG_DISPLAYWIDTH 1439
	ER_XAER_DUPID 1440
	ER_DATETIME_FUNCTION_OVERFLOW 1441
	ER_CANT_UPDATE_USED_TABLE_IN_SF_OR_TRG 1442
	ER_VIEW_PREVENT_UPDATE 1443
	ER_PS_NO_RECURSION 1444
	ER_SP_CANT_SET_AUTOCOMMIT 1445
	ER_MALFORMED_DEFINER 1446
	ER_VIEW_FRM_NO_USER 1447
	ER_VIEW_OTHER_USER 1448
	ER_NO_SUCH_USER 1449
	ER_FORBID_SCHEMA_CHANGE 1450
	ER_ROW_IS_REFERENCED_2 1451
	ER_NO_REFERENCED_ROW_2 1452
	ER_SP_BAD_VAR_SHADOW 1453
	ER_TRG_NO_DEFINER 1454
	ER_OLD_FILE_FORMAT 1455
	ER_SP_RECURSION_LIMIT 1456
	ER_SP_PROC_TABLE_CORRUPT 1457
	ER_SP_WRONG_NAME 1458
	ER_TABLE_NEEDS_UPGRADE 1459
	ER_SP_NO_AGGREGATE 1460
	ER_MAX_PREPARED_STMT_COUNT_REACHED 1461
	ER_VIEW_RECURSIVE 1462
	ER_NON_GROUPING_FIELD_USED 1463
	ER_TABLE_CANT_HANDLE_SPKEYS 1464
	ER_NO_TRIGGERS_ON_SYSTEM_SCHEMA 1465
	ER_REMOVED_SPACES 1466
	ER_AUTOINC_READ_FAILED 1467
	ER_USERNAME 1468
	ER_HOSTNAME 1469
	ER_WRONG_STRING_LENGTH 1470
	ER_NON_INSERTABLE_TABLE 1471
	ER_ADMIN_WRONG_MRG_TABLE 1472
	ER_TOO_HIGH_LEVEL_OF_NESTING_FOR_SELECT 1473
	ER_NAME_BECOMES_EMPTY 1474
	ER_AMBIGUOUS_FIELD_TERM 1475
	ER_FOREIGN_SERVER_EXISTS 1476
	ER_FOREIGN_SERVER_DOESNT_EXIST 1477
	ER_ILLEGAL_HA_CREATE_OPTION 1478
	ER_PARTITION_REQUIRES_VALUES_ERROR 1479
	ER_PARTITION_WRONG_VALUES_ERROR 1480
	ER_PARTITION_MAXVALUE_ERROR 1481
	ER_PARTITION_SUBPARTITION_ERROR 1482
	ER_PARTITION_SUBPART_MIX_ERROR 1483
	ER_PARTITION_WRONG_NO_PART_ERROR 1484
	ER_PARTITION_WRONG_NO_SUBPART_ERROR 1485
	ER_WRONG_EXPR_IN_PARTITION_FUNC_ERROR 1486
	ER_NO_CONST_EXPR_IN_RANGE_OR_LIST_ERROR 1487
	ER_FIELD_NOT_FOUND_PART_ERROR 1488
	ER_LIST_OF_FIELDS_ONLY_IN_HASH_ERROR 1489
	ER_INCONSISTENT_PARTITION_INFO_ERROR 1490
	ER_PARTITION_FUNC_NOT_ALLOWED_ERROR 1491
	ER_PARTITIONS_MUST_BE_DEFINED_ERROR 1492
	ER_RANGE_NOT_INCREASING_ERROR 1493
	ER_INCONSISTENT_TYPE_OF_FUNCTIONS_ERROR 1494
	ER_MULTIPLE_DEF_CONST_IN_LIST_PART_ERROR 1495
	ER_PARTITION_ENTRY_ERROR 1496
	ER_MIX_HANDLER_ERROR 1497
	ER_PARTITION_NOT_DEFINED_ERROR 1498
	ER_TOO_MANY_PARTITIONS_ERROR 1499
	ER_SUBPARTITION_ERROR 1500
	ER_CANT_CREATE_HANDLER_FILE 1501
	ER_BLOB_FIELD_IN_PART_FUNC_ERROR 1502
	ER_UNIQUE_KEY_NEED_ALL_FIELDS_IN_PF 1503
	ER_NO_PARTS_ERROR 1504
	ER_PARTITION_MGMT_ON_NONPARTITIONED 1505
	ER_FOREIGN_KEY_ON_PARTITIONED 1506
	ER_DROP_PARTITION_NON_EXISTENT 1507
	ER_DROP_LAST_PARTITION 1508
	ER_COALESCE_ONLY_ON_HASH_PARTITION 1509
	ER_REORG_HASH_ONLY_ON_SAME_NO 1510
	ER_REORG_NO_PARAM_ERROR 1511
	ER_ONLY_ON_RANGE_LIST_PARTITION 1512
	ER_ADD_PARTITION_SUBPART_ERROR 1513
	ER_ADD_PARTITION_NO_NEW_PARTITION 1514
	ER_COALESCE_PARTITION_NO_PARTITION 1515
	ER_REORG_PARTITION_NOT_EXIST 1516
	ER_SAME_NAME_PARTITION 1517
	ER_NO_BINLOG_ERROR 1518
	ER_CONSECUTIVE_REORG_PARTITIONS 1519
	ER_REORG_OUTSIDE_RANGE 1520
	ER_PARTITION_FUNCTION_FAILURE 1521
	ER_PART_STATE_ERROR 1522
	ER_LIMITED_PART_RANGE 1523
	ER_PLUGIN_IS_NOT_LOADED 1524
	ER_WRONG_VALUE 1525
	ER_NO_PARTITION_FOR_GIVEN_VALUE 1526
	ER_FILEGROUP_OPTION_ONLY_ONCE 1527
	ER_CREATE_FILEGROUP_FAILED 1528
	ER_DROP_FILEGROUP_FAILED 1529
	ER_TABLESPACE_AUTO_EXTEND_ERROR 1530
	ER_WRONG_SIZE_NUMBER 1531
	ER_SIZE_OVERFLOW_ERROR 1532
	ER_ALTER_FILEGROUP_FAILED 1533
	ER_BINLOG_ROW_LOGGING_FAILED 1534
	ER_BINLOG_ROW_WRONG_TABLE_DEF 1535
	ER_BINLOG_ROW_RBR_TO_SBR 1536
	ER_EVENT_ALREADY_EXISTS 1537
	ER_EVENT_STORE_FAILED 1538
	ER_EVENT_DOES_NOT_EXIST 1539
	ER_EVENT_CANT_ALTER 1540
	ER_EVENT_DROP_FAILED 1541
	ER_EVENT_INTERVAL_NOT_POSITIVE_OR_TOO_BIG 1542
	ER_EVENT_ENDS_BEFORE_STARTS 1543
	ER_EVENT_EXEC_TIME_IN_THE_PAST 1544
	ER_EVENT_OPEN_TABLE_FAILED 1545
	ER_EVENT_NEITHER_M_EXPR_NOR_M_AT 1546
	ER_COL_COUNT_DOESNT_MATCH_CORRUPTED 1547
	ER_CANNOT_LOAD_FROM_TABLE 1548
	ER_EVENT_CANNOT_DELETE 1549
	ER_EVENT_COMPILE_ERROR 1550
	ER_EVENT_SAME_NAME 1551
	ER_EVENT_DATA_TOO_LONG 1552
	ER_DROP_INDEX_FK 1553
	ER_WARN_DEPRECATED_SYNTAX_WITH_VER 1554
	ER_CANT_WRITE_LOCK_LOG_TABLE 1555
	ER_CANT_LOCK_LOG_TABLE 1556
	ER_FOREIGN_DUPLICATE_KEY 1557
	ER_COL_COUNT_DOESNT_MATCH_PLEASE_UPDATE 1558
	ER_TEMP_TABLE_PREVENTS_SWITCH_OUT_OF_RBR 1559
	ER_STORED_FUNCTION_PREVENTS_SWITCH_BINLOG_FORMAT 1560
	ER_NDB_CANT_SWITCH_BINLOG_FORMAT 1561
	ER_PARTITION_NO_TEMPORARY 1562
	ER_PARTITION_CONST_DOMAIN_ERROR 1563
	ER_PARTITION_FUNCTION_IS_NOT_ALLOWED 1564
	ER_DDL_LOG_ERROR 1565
	ER_NULL_IN_VALUES_LESS_THAN 1566
	ER_WRONG_PARTITION_NAME 1567
	ER_CANT_CHANGE_TX_ISOLATION 1568
	ER_DUP_ENTRY_AUTOINCREMENT_CASE 1569
	ER_EVENT_MODIFY_QUEUE_ERROR 1570
	ER_EVENT_SET_VAR_ERROR 1571
	ER_PARTITION_MERGE_ERROR 1572
	ER_CANT_ACTIVATE_LOG 1573
	ER_RBR_NOT_AVAILABLE 1574
	ER_BASE64_DECODE_ERROR 1575
	ER_EVENT_RECURSION_FORBIDDEN 1576
	ER_EVENTS_DB_ERROR 1577
	ER_ONLY_INTEGERS_ALLOWED 1578
	ER_UNSUPORTED_LOG_ENGINE 1579
	ER_BAD_LOG_STATEMENT 1580
	ER_CANT_RENAME_LOG_TABLE 1581
	ER_WRONG_PARAMCOUNT_TO_NATIVE_FCT 1582
	ER_WRONG_PARAMETERS_TO_NATIVE_FCT 1583
	ER_WRONG_PARAMETERS_TO_STORED_FCT 1584
	ER_NATIVE_FCT_NAME_COLLISION 1585
	ER_DUP_ENTRY_WITH_KEY_NAME 1586
	ER_BINLOG_PURGE_EMFILE 1587
	ER_EVENT_CANNOT_CREATE_IN_THE_PAST 1588
	ER_EVENT_CANNOT_ALTER_IN_THE_PAST 1589
	ER_SLAVE_INCIDENT 1590
	ER_NO_PARTITION_FOR_GIVEN_VALUE_SILENT 1591
	ER_BINLOG_UNSAFE_STATEMENT 1592
	ER_SLAVE_FATAL_ERROR 1593
	ER_SLAVE_RELAY_LOG_READ_FAILURE 1594
	ER_SLAVE_RELAY_LOG_WRITE_FAILURE 1595
	ER_SLAVE_CREATE_EVENT_FAILURE 1596
	ER_SLAVE_MASTER_COM_FAILURE 1597
	ER_BINLOG_LOGGING_IMPOSSIBLE 1598
	ER_VIEW_NO_CREATION_CTX 1599
	ER_VIEW_INVALID_CREATION_CTX 1600
	ER_SR_INVALID_CREATION_CTX 1601
	ER_TRG_CORRUPTED_FILE 1602
	ER_TRG_NO_CREATION_CTX 1603
	ER_TRG_INVALID_CREATION_CTX 1604
	ER_EVENT_INVALID_CREATION_CTX 1605
	ER_TRG_CANT_OPEN_TABLE 1606
	ER_CANT_CREATE_SROUTINE 1607
	ER_NEVER_USED 1608
	ER_NO_FORMAT_DESCRIPTION_EVENT_BEFORE_BINLOG_STATEMENT 1609
	ER_SLAVE_CORRUPT_EVENT 1610
	ER_LOAD_DATA_INVALID_COLUMN 1611
	ER_LOG_PURGE_NO_FILE 1612
	ER_XA_RBTIMEOUT 1613
	ER_XA_RBDEADLOCK 1614
	ER_NEED_REPREPARE 1615
	ER_DELAYED_NOT_SUPPORTED 1616
	WARN_NO_MASTER_INFO 1617
	WARN_OPTION_IGNORED 1618
	WARN_PLUGIN_DELETE_BUILTIN 1619
	WARN_PLUGIN_BUSY 1620
	ER_VARIABLE_IS_READONLY 1621
	ER_WARN_ENGINE_TRANSACTION_ROLLBACK 1622
	ER_SLAVE_HEARTBEAT_FAILURE 1623
	ER_SLAVE_HEARTBEAT_VALUE_OUT_OF_RANGE 1624
	ER_NDB_REPLICATION_SCHEMA_ERROR 1625
	ER_CONFLICT_FN_PARSE_ERROR 1626
	ER_EXCEPTIONS_WRITE_ERROR 1627
	ER_TOO_LONG_TABLE_COMMENT 1628
	ER_TOO_LONG_FIELD_COMMENT 1629
	ER_FUNC_INEXISTENT_NAME_COLLISION 1630
	ER_DATABASE_NAME 1631
	ER_TABLE_NAME 1632
	ER_PARTITION_NAME 1633
	ER_SUBPARTITION_NAME 1634
	ER_TEMPORARY_NAME 1635
	ER_RENAMED_NAME 1636
	ER_TOO_MANY_CONCURRENT_TRXS 1637
	WARN_NON_ASCII_SEPARATOR_NOT_IMPLEMENTED 1638
	ER_DEBUG_SYNC_TIMEOUT 1639
	ER_DEBUG_SYNC_HIT_LIMIT 1640
	ER_DUP_SIGNAL_SET 1641
	ER_SIGNAL_WARN 1642
	ER_SIGNAL_NOT_FOUND 1643
	ER_SIGNAL_EXCEPTION 1644
	ER_RESIGNAL_WITHOUT_ACTIVE_HANDLER 1645
	ER_SIGNAL_BAD_CONDITION_TYPE 1646
	WARN_COND_ITEM_TRUNCATED 1647
	ER_COND_ITEM_TOO_LONG 1648
	ER_UNKNOWN_LOCALE 1649
	ER_SLAVE_IGNORE_SERVER_IDS 1650
	ER_QUERY_CACHE_DISABLED 1651
	ER_SAME_NAME_PARTITION_FIELD 1652
	ER_PARTITION_COLUMN_LIST_ERROR 1653
	ER_WRONG_TYPE_COLUMN_VALUE_ERROR 1654
	ER_TOO_MANY_PARTITION_FUNC_FIELDS_ERROR 1655
	ER_MAXVALUE_IN_VALUES_IN 1656
	ER_TOO_MANY_VALUES_ERROR 1657
	ER_ROW_SINGLE_PARTITION_FIELD_ERROR 1658
	ER_FIELD_TYPE_NOT_ALLOWED_AS_PARTITION_FIELD 1659
	ER_PARTITION_FIELDS_TOO_LONG 1660
	ER_BINLOG_ROW_ENGINE_AND_STMT_ENGINE 1661
	ER_BINLOG_ROW_MODE_AND_STMT_ENGINE 1662
	ER_BINLOG_UNSAFE_AND_STMT_ENGINE 1663
	ER_BINLOG_ROW_INJECTION_AND_STMT_ENGINE 1664
	ER_BINLOG_STMT_MODE_AND_ROW_ENGINE 1665
	ER_BINLOG_ROW_INJECTION_AND_STMT_MODE 1666
	ER_BINLOG_MULTIPLE_ENGINES_AND_SELF_LOGGING_ENGINE 1667
	ER_BINLOG_UNSAFE_LIMIT 1668
	ER_BINLOG_UNSAFE_INSERT_DELAYED 1669
	ER_BINLOG_UNSAFE_SYSTEM_TABLE 1670
	ER_BINLOG_UNSAFE_AUTOINC_COLUMNS 1671
	ER_BINLOG_UNSAFE_UDF 1672
	ER_BINLOG_UNSAFE_SYSTEM_VARIABLE 1673
	ER_BINLOG_UNSAFE_SYSTEM_FUNCTION 1674
	ER_BINLOG_UNSAFE_NONTRANS_AFTER_TRANS 1675
	ER_MESSAGE_AND_STATEMENT 1676
	ER_SLAVE_CONVERSION_FAILED 1677
	ER_SLAVE_CANT_CREATE_CONVERSION 1678
	ER_INSIDE_TRANSACTION_PREVENTS_SWITCH_BINLOG_FORMAT 1679
	ER_PATH_LENGTH 1680
	ER_WARN_DEPRECATED_SYNTAX_NO_REPLACEMENT 1681
	ER_WRONG_NATIVE_TABLE_STRUCTURE 1682
	ER_WRONG_PERFSCHEMA_USAGE 1683
	ER_WARN_I_S_SKIPPED_TABLE 1684
	ER_INSIDE_TRANSACTION_PREVENTS_SWITCH_BINLOG_DIRECT 1685
	ER_STORED_FUNCTION_PREVENTS_SWITCH_BINLOG_DIRECT 1686
	ER_SPATIAL_MUST_HAVE_GEOM_COL 1687
	ER_TOO_LONG_INDEX_COMMENT 1688
	ER_LOCK_ABORTED 1689
	ER_DATA_OUT_OF_RANGE 1690
	ER_WRONG_SPVAR_TYPE_IN_LIMIT 1691
	ER_BINLOG_UNSAFE_MULTIPLE_ENGINES_AND_SELF_LOGGING_ENGINE 1692
	ER_BINLOG_UNSAFE_MIXED_STATEMENT 1693
	ER_INSIDE_TRANSACTION_PREVENTS_SWITCH_SQL_LOG_BIN 1694
	ER_STORED_FUNCTION_PREVENTS_SWITCH_SQL_LOG_BIN 1695
	ER_FAILED_READ_FROM_PAR_FILE 1696
	ER_VALUES_IS_NOT_INT_TYPE_ERROR 1697
	ER_ACCESS_DENIED_NO_PASSWORD_ERROR 1698
	ER_SET_PASSWORD_AUTH_PLUGIN 1699
	ER_GRANT_PLUGIN_USER_EXISTS 1700
	ER_TRUNCATE_ILLEGAL_FK 1701
	ER_PLUGIN_IS_PERMANENT 1702
	ER_SLAVE_HEARTBEAT_VALUE_OUT_OF_RANGE_MIN 1703
	ER_SLAVE_HEARTBEAT_VALUE_OUT_OF_RANGE_MAX 1704
	ER_STMT_CACHE_FULL 1705
	ER_MULTI_UPDATE_KEY_CONFLICT 1706
	ER_TABLE_NEEDS_REBUILD 1707
	WARN_OPTION_BELOW_LIMIT 1708
	ER_INDEX_COLUMN_TOO_LONG 1709
	ER_ERROR_IN_TRIGGER_BODY 1710
	ER_ERROR_IN_UNKNOWN_TRIGGER_BODY 1711
	ER_INDEX_CORRUPT 1712
	ER_UNDO_RECORD_TOO_BIG 1713
	ER_BINLOG_UNSAFE_INSERT_IGNORE_SELECT 1714
	ER_BINLOG_UNSAFE_INSERT_SELECT_UPDATE 1715
	ER_BINLOG_UNSAFE_REPLACE_SELECT 1716
	ER_BINLOG_UNSAFE_CREATE_IGNORE_SELECT 1717
	ER_BINLOG_UNSAFE_CREATE_REPLACE_SELECT 1718
	ER_BINLOG_UNSAFE_UPDATE_IGNORE 1719
	ER_PLUGIN_NO_UNINSTALL 1720
	ER_PLUGIN_NO_INSTALL 1721
	ER_BINLOG_UNSAFE_WRITE_AUTOINC_SELECT 1722
	ER_BINLOG_UNSAFE_CREATE_SELECT_AUTOINC 1723
	ER_BINLOG_UNSAFE_INSERT_TWO_KEYS 1724
	ER_TABLE_IN_FK_CHECK 1725
	ER_UNSUPPORTED_ENGINE 1726
	ER_BINLOG_UNSAFE_AUTOINC_NOT_FIRST 1727
	ER_ERROR_LAST 1727
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
		stream-end?:		;are there more rows to be read?
		more-results?:
		expecting: none
		buffer: none
		cache: none
	;-------
		auto-commit: on		; not used, just reserved for /Command compatibility.
		rows: 10			; not used, just reserved for /Command compatibility.
		auto-conv?: on
		auto-ping?: on
		flat?: off
		delimiter: #";"
		newlines?: value? 'new-line
		last-insert-ids: make block! 1
		matched-rows: 0
		init:
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
		catalog: db: org_table: org_name: charsetnr: length: default: none
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
	
	set 'mysql-map-rebol-values func [data [block!] /local args sql mark][
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

	read-string: [[copy string to null null] | [copy string to end]] ;null-terminated string
	read-byte: [copy byte byte-char (byte: to integer! to char! :byte)]

	;mysql uses little endian for all integers
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
			long: to-integer b0 or (shift/left b1 8) or (shift/left b2 16) or (shift/left b3 24) ;use or instead of arithmetic operations since rebol doesn't handle unsigned integers and the number could be larger than (2^31 - 1)
		)
	]
	read-long64: [
		read-long
		skip 4 byte (net-log "Warning: long64 type detected !")
	]
	read-length: [; length coded binary
		#"^(FB)" (len: 0 null-flag: true)
		| #"^(FC)" read-int (len: int)
		| #"^(FD)" read-int24 (len: int24)
		| #"^(FE)" read-long64 (len: long)
		| read-byte (len: byte)
	]
	read-field: [ ;length coded string
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
		;print ["read-packet expecting: " pl/expecting]
		
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
	
		switch status [
			255 [
				parse/all next pl/buffer case [
					pl/capabilities and defs/client/protocol-41 [
						[
							read-int 	(pl/error-code: int)
							6 skip
							read-string (pl/error-msg: string)
						]
					]
					any [none? pl/protocol pl/protocol > 9][
						[
							read-int 	(pl/error-code: int)
							read-string (pl/error-msg: string)
						]
					]
					true [
						pl/error-code: 0
						[read-string (pl/error-msg: string)]
					]
				]
				pl/stream-end?: true			
				pl/more-results?: false ;no more results following an error. It's not documented, but we don't have a server status word for this, so this should be a valid assumption, and it's confirmed by testing.
				make error! reduce ['MySQL-errors 'message pl/error-code pl/error-msg]
			]
			254 [
				case [
					packet-len = 5 [
						pl/more-results?: not zero? pl/buffer/4 and 8
						pl/stream-end?: true
					]
					packet-len = 1 [pl/stream-end?: true]
				]
			]
			0 [
				if none? pl/expecting [
					parse/all/case next pl/buffer [
						read-length	(pl/matched-rows: pl/matched-rows + len)
						read-length (if len > 0 [append pl/last-insert-ids len])
						read-int	(pl/more-results?: not zero? int and 8)
					]
					pl/stream-end?: true
				]
			]
		]
		;print ["read-packet stream-end?" pl/stream-end? "more-results:" pl/more-results?]
		;print ["read-packet returns:" pl/buffer]
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
	
	read-columns-number: func [port [port!] /local colnb pl][
		pl: port/locals
		parse/all/case read-packet port [
			read-length (if zero? colnb: len [pl/stream-end?: true])
		]
		;print ["read-columns-number returns" colnb]
		colnb
	]
	
	read-columns-headers: func [port [port!] cols [integer!] /local pl col pack][
		;print ["read-columns-headers"]
		pl: port/locals
		pl/columns: make block! cols
		loop cols [
			col: make column-class []
			pack: read-packet port
			either pl/capabilities and defs/client/protocol-41 [
				parse/all/case pack [
					read-field 	(col/catalog: field)
					read-field 	(col/db: field)
					read-field	(col/table:	field)
					read-field	(col/org_table:	field)
					read-field	(col/name: 	field)
					read-field	(col/org_name: 	field)
					read-byte	;filler
					read-int	(col/charsetnr: int)
					read-long	(col/length: long)
					read-byte	(col/type: decode/type byte)
					read-int	(col/flags: decode/flags int)
					read-byte	(col/decimals: byte)
					read-int	;filler, always 0
					read-length	(col/default: len)
				]
			][
				parse/all/case pack [
					read-field	(col/table:	field)
					read-field	(col/name: 	field)
					read-length	(col/length: len)
					read-length	(col/type: decode/type len)
					read-length	(col/flags: decode/flags len)
					read-byte	(col/decimals: byte)
				]
			]
			append pl/columns :col
		]
		read-packet	port			; check the ending flag
		if not pl/stream-end? [
			flush-pending-data port
			net-error "Error: end of columns stream not found"
		]
		pl/expecting: 'rows
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
			if empty? row-data [pl/expecting: none return rows]		; empty set
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
		if pl/stream-end? [pl/expecting: none]
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
	
	flush-pending-data: func [port [port!] /local pl len EOF?][
		if throws/closed = catch [
			net-log "flushing unread data..."
			copy port
		][
			try-reconnect port
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
		if 0 >= write-io port/sub-port data length? data [
			throw throws/closed
		]
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
		net-log reform ["insert-query:" data]
		send-cmd port defs/cmd/query data
		colnb: read-columns-number port
		if not any [zero? colnb port/locals/stream-end?][
			read-columns-headers port colnb
		]
		none
	]
	
	insert-all-queries: func [port [port!] data [string!] /local s e res d][
		d: port/locals/delimiter
		parse/all s: data [
			any [
				#"#" thru newline
				| #"'" any ["\\" | "\'" | "''" | not-squote] #"'"
				|{"} any [{\"} | {""} | not-dquote] {"}
				| #"`" thru #"`"
				| "begin" thru "end"
				| e: d (
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
		port/state/flags: port/state/flags or 1024 or 2 ; avoid triggering READ special actions + reset closed flag
		open port
	]
	
	check-opened: func [port [port!]][	
		if not zero? port/sub-port/state/flags and 1024 [
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

		unless parse/all read-packet port [
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
		][
			make error! rejoin ["failed to parse the greeting from the server:" mold pl/buffer "," mold pl]
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
		client-param: either pl/capabilities and defs/client/protocol-41 [
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
		auth-pack: either pl/capabilities and defs/client/protocol-41 [
			rejoin [
				write-long client-param
				;write-long (length? port/user) + (length? port/pass)
				;	+ 7 + std-header-length
				write-long to integer! #1000000 ;max packet length, the value 16M is from mysql.exe
				write-byte pl/character-set
				{^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@^@} ;23 0's
				write-string port/user
				write-byte length? key: scramble port/pass port
				key
				write-string any [port/path "^@"]
			]
		][
			rejoin [
				write-int client-param
				write-int24 (length? port/user) + (length? port/pass)
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
		if all [string? data data/1 = #"["][data: load data]
		res: either block? data [
			if empty? data [net-error "No data!"]
			either string? data/1 [
				insert-query port mysql-map-rebol-values data
			][
				insert-cmd port data
			]
		][
			either port/locals/capabilities and defs/client/protocol-41 [
				insert-query port data
			][
				insert-all-queries port data
			]
		]
		res
	]
	
	pick: func [port [port!] data][
		either any [none? data data = 1][
			either port/locals/stream-end? [copy* []][copy/part port 1]
		][none]
	]

	copy: func [port /part data [integer!] /local pl colnb exit? ret tmp][
		;print ["copy from the port, expecting:" port/locals/expecting]
		check-opened port
		pl: port/locals
		ret: none
		next?: false
		
		if all [not pl/stream-end?
				pl/expecting = 'rows] [
			either all [value? 'part part][
				tmp: read-rows/part port data
				unless none? tmp [
					if none? ret [ret: copy* []]
					append ret tmp
					data: data - length? tmp
				]
			][
				tmp: read-rows port
				unless none? tmp [
					if none? ret [ret: copy* []]
					append ret tmp
				]
			]
		]

		while [all [any [not part data > 0]
					pl/more-results?]] [
			;print ["gonna retrieve more results, expecting" pl/expecting]
			if pl/expecting <> 'rows[
				colnb: read-columns-number port
				;print ["colnb: " colnb]
				next?: any [zero? colnb pl/stream-end?]
				if not next? [
					read-columns-headers port colnb
				]
			]
			;print ["__expecting__:" pl/expecting "next?:" next? "data:" data "stream-end?:" pl/stream-end?]
			while [not any [next? pl/stream-end?
							all [part data <= 0]]][
				either all [value? 'part part][
					tmp: read-rows/part port data
					unless none? tmp [
						if none? ret [ret: copy* []]
						append ret tmp
						data: data - length? tmp
					]
				][
					tmp: read-rows port
					unless none? tmp [
						if none? ret [ret: copy* []]
						append ret tmp
					]
				]
			]
		]
		;print ["copy returns: " ret]
		if none? ret [
			case [
				not empty? pl/last-insert-ids [
					ret: copy* pl/last-insert-ids 
					clear pl/last-insert-ids
				]
				'else [
					ret: pl/matched-rows
					pl/matched-rows: 0
				]
			]
		]
		ret
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

	;insert a new error type
	system/error: make system/error [
		MySQL-errors: make object! [;arg1: [error code]; arg2: error message]
			code: 3000
			type: "MySQL errors"
			message: ["Error (" :arg1 ")" :arg2]
		]
	]
]

