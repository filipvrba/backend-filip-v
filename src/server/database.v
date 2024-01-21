module server

import db.sqlite
import os
import src.cli
import rb

pub struct Database {
pub:
	sqlite sqlite.DB
}

fn get_database(length u8) map[string]Database {
	mut database := map[string]Database
	mut db_names := get_db_names(length)
	mut path := static_dir

	if os.exists(static_dir_media) {
		path = os.join_path_single(static_dir_media, static_dir)
	}

	if !os.exists(path) {
		os.mkdir_all(path) or {panic(err)}
	}

	for name in db_names {
		database[name] = Database{
			sqlite.connect('$path/${name}.db') or { panic(err) }
		}

		unsafe{
			database[name].create_tables() or { panic(err) }
			database[name].create_rows() or { panic(err) }
			database[name].print_authorization(name) or { panic(err) }
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
	rows := d.sqlite.exec("$query;") or {
		return error(err.str())
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

fn (d Database) create_tables() ! {
	sql d.sqlite {
		create table Authorization
	}!
	sql d.sqlite {
		create table Guard
	}!
}

fn (d Database) create_rows() ! {
	d.create_row_authorization()!
}

fn (d Database) create_row_authorization() ! {
	select_auth := sql d.sqlite {
		select from Authorization
	} or { []Authorization{} }

	if select_auth.len == 0 {
		auth := Authorization{
			client_token: cli.get_token(32).self
			server_token: cli.get_token(64).self
		}
		sql d.sqlite {
			include auth into Authorization
		}!
	}
}

fn (d Database) print_authorization(name string) ! {
	select_auth := sql d.sqlite {
		select from Authorization
	} or { []Authorization{} }[0]
	
	rb.Event{name: "authorization"}.println('$name \{\n' +
		'\tclient_token: ${select_auth.client_token}\n' +
		'\tserver_token: ${select_auth.server_token}' +
	'\n\}')
}
