module cli

import jp
import x.json2
import rb

pub struct Configuration {
pub mut:
	json_parser jp.JsonParser
}

pub const(
	key_db = "database"
)

pub fn get_config() Configuration {
	mut config := Configuration{}
	config.json_parser = jp.JsonParser{path: path_config }
	config.json_parser.on(key_db, []json2.Any{})
	return config
}

pub fn (mut c Configuration) add_database(name string) {
	mut database := c.json_parser.get(key_db).arr()
	if !database.any(it.str() == name) {
		database << name
		c.json_parser.set(key_db, database)
		rb.Event{name: "set"}.println("$key_db: $name")
	}
	else {
		rb.Event{name: "warning"}.println("The '$name' database has already been entered.")
	}
}

pub fn (mut c Configuration) remove_database(name string) {
	mut database := c.json_parser.get(key_db).arr()
	if database.any(it.str() == name) {
		mut index := -1
		for i in 0 .. database.len {
			if database[i].str() == name {
				index = i
			}
		}

		database.delete(index)
		c.json_parser.set(key_db, database)
		rb.Event{name: "remove"}.println("$key_db: $name")
	}
	else {
		rb.Event{name: "warning"}.println(
			"The '$name' database does not exist and therefore will not be removed."
		)
	}
}

pub fn (mut c Configuration) get_database_str() string {
	database := c.json_parser.get_data()
	return database[key_db] or {""}.prettify_json_str()
}
