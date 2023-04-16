# backend-filip-v

## Dev Notes
Write notes here, for the development of this project.

*Pseudocode:*
```txt
http -> /api/v1/database

	get -> token/database/query
		= result values from db
	post | delete ->
		body
			- token
			- database
			- query
		= result mesage
=== method ===
fn get_api_database
fn post_api_database
fn delete_api_database
```

*SQL examples:*
```sql
CREATE TABLE profiles (name TEXT, year INTEGER);
INSERT INTO profiles (name, year) VALUES ("filip", 27);
```

*Logic for getting the column name into **exec(...)** function was added to db.sqlite module:*
```v
// 84
pub struct Row {
pub mut:
	cols []string
	vals []string
}
// 90
// ...
// 230
col := unsafe { &char(C.sqlite3_column_name(stmt, i)) }
if col == &char(0) {
	row.cols << ''
} else {
	row.cols << unsafe { tos_clone(col) }
}
// 237
```