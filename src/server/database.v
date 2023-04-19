module server

import db.sqlite
import os

pub struct Database {
pub:
	sqlite sqlite.DB
}

fn get_database(length u8) map[string]Database {
	mut database := map[string]Database
	mut db_names := get_db_names(length)

	if !os.exists(static_dir) {
		os.mkdir_all(static_dir) or {panic(err)}
	}

	for name in db_names {
		database[name] = Database{
			sqlite.connect('$static_dir/${name}.db') or { panic(err) }
		}
	}
	return database
}

fn get_db_names(length u8) []string {
	mut result := []string{}
	for i in 1 .. (length + 1) {
		result << i.str()
	}
	return result
}

fn (d Database) exec(query string) ![]map[string]string {
	rows, status_code := d.sqlite.exec("$query;")
	if status_code != 101 {
		return error(status_code.str())
	}

	mut rows_arr := []map[string]string{}

	for row in rows {
		mut rows_map := map[string]string
		for ci in 0 .. row.cols.len {
			rows_map[row.cols[ci]] = row.vals[ci]
		}
		rows_arr << rows_map
	}
	return rows_arr
}