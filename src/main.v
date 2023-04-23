module main

import src.cli
import src.server
import rb

struct BackendFilip {
mut:
	cli cli.Cli
}

fn main() {
	mut bef := BackendFilip{}

	if bef.cli.arguments.token_length > 0 {
		rb.Event{name: "token"}.println("${cli.get_token(bef.cli.arguments.token_length).self}")
		exit(0)
	}
	else if bef.cli.arguments.server > 0 {
		server.new(bef.cli.arguments.server)
	}
}
