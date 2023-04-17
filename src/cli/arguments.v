module cli

import op
import rb

pub struct Arguments {
pub mut:
	is_server bool
	is_token bool
	add_db string
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
	option_parser.on("server", "", "Starts the web server\n", fn [mut ref_args] (_ string) {
		ref_args.is_server = true
	})
	option_parser.on("-adb NAME", "--add-db NAME",
			"Adds another database to the\nconfiguration file.", fn [mut ref_args] (name string) {
		ref_args.add_db = name
	})
	option_parser.on("-gt", "--get-token",
			"To secure API server access, this function\n" +
                                   "generates a token with a specified length\n" +
                                   "(manual entry of the token into the ENV\n" +
                                   "is required).\n" +
                                   "The default: $token_length length.", fn [mut ref_args] (_ string) {
		ref_args.is_token = true
	})
	option_parser.on("-h", "--help", "Show help", fn [mut ref_op] (_ string) {
		print(ref_op.help_str())
		exit(0)
	})
	option_parser.on("-v", "--version", "Show version", fn (_ string) {
		rb.Event{name: 'version'}.println(version)
		exit(0)
	})
	option_parser.init()

	return arguments
}