module cli

import op
import rb

pub struct Arguments {
pub mut:
	is_token bool
	is_get_db bool
	server u8
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
	option_parser.on("server LENGTH", "", "Starts a web server with a defined\n" +
					 "value to create many databases\n" +
					 "(The LENGTH value has a range from 1 to 255).\n", fn [mut ref_args] (length string) {
		ref_args.server = length.u8()
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
