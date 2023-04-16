module main

import src.cli
import src.server

struct BackendFilip {
mut:
	cli cli.Cli
}

fn main() {
	mut bef := BackendFilip{}
	if bef.cli.arguments.is_server {
		server.new(bef.cli.arguments)
	}
}
