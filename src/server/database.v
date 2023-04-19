module server

import db.sqlite
import src.cli

pub struct Database {
pub:
	sqlite sqlite.DB
}

fn get_database(config cli.Configuration) map[string]Database {
	mut database := map[string]Database
	mut json_parser := config.json_parser
	mut db_names := json_parser.get(cli.key_db)
	for name in db_names.arr() {
		database[name.str()] = Database{
			sqlite.connect('$static_dir/${name}.db') or { panic(err) }
		}
	}
	return database
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