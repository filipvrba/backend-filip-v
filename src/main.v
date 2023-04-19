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

	if bef.cli.arguments.is_token {
		rb.Event{name: "token"}.println("BEF_CLIENT: ${cli.get_token(32).self}")
		rb.Event{name: "token"}.println("BEF_SERVER: ${cli.get_token(64).self}")
		exit(0)
	}
	else if bef.cli.arguments.server > 0 {
		server.new(bef.cli.arguments.server)
	}
}
