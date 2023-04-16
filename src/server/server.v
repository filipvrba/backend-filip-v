module server

import vweb
import db.sqlite
import os
import src.cli

const (
	port = 8080
	static_dir = 'src/public'
    token = os.environ()["BEF_TOKEN"]
)

pub struct Server {
	vweb.Context
pub mut:
	db sqlite.DB
mut:
	arguments cli.Arguments [vweb_global]
}

pub fn new(arguments cli.Arguments) {
	
	vweb.run_at(new_server(arguments), vweb.RunParams{
        port: port
    }) or { panic(err) }
}

fn new_server(arguments cli.Arguments) &Server {
	
	mut server := &Server{
		arguments: cli.Arguments{
			true
		}
		db: sqlite.connect('cv.sqlite') or { panic(err) }
	}
	server.handle_static(static_dir, true)
	return server
}

pub fn (mut s Server) before_request() {
	// println(s.arguments)
}