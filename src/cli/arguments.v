module cli

import op
import rb

pub struct Arguments {
pub mut:
	is_server bool
	is_token bool
	is_get_db bool
	add_db string
	remove_db string
}

pub fn get_arguments() Arguments {
	mut arguments := Arguments{}
	mut ref_args := &arguments

	mut option_parser := op.OptionParser{}
	mut ref_op := &option_parser

	option_parser.banner('This $app_full_name application serves as \n' +
	'a backend in the form of a REST API.\n\n' +
	'Usage: $app_name [oprions]' +
	'\n\nOptions:')
	option_parser.on("server", "", "Starts the web server.\n", fn [mut ref_args] (_ string) {
		ref_args.is_server = true
	})
	option_parser.on("-adb NAME", "--add-db NAME",
			"Adds another database to the\nconfiguration file.", fn [mut ref_args] (name string) {
		ref_args.add_db = name
	})
	option_parser.on("-rdb NAME", "--remove-db NAME",
			"Removes the database name from\nthe configuration file.", fn [mut ref_args] (name string) {
		ref_args.remove_db = name
	})
	option_parser.on("-gdb", "--get-db",
			"Prints a list of added databases.", fn [mut ref_args] (_ string) {
		ref_args.is_get_db = true
	})
	option_parser.on("-gt", "--get-token",
			"Generates tokens for client and server\n" +
			"(Client is for GET and\nServer is for DB change).", fn [mut ref_args] (_ string) {
		ref_args.is_token = true
	})
	l_helper := fn [mut ref_op] (_ string) {
		print(ref_op.help_str())
		exit(0)
	}
	option_parser.on("-h", "--help", "Show help", l_helper)
	option_parser.on("-v", "--version", "Show version", fn (_ string) {
		rb.Event{name: 'version'}.println(version)
		exit(0)
	})
	option_parser.init()

	if !option_parser.have_arguments() {
		l_helper("")
	}

	return arguments
}
