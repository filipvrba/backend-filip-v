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
	config cli.Configuration [vweb_global]
}

pub fn new(config cli.Configuration) {
	
	vweb.run_at(new_server(config), vweb.RunParams{
        port: port
    }) or { panic(err) }
}

fn new_server(config cli.Configuration) &Server {
	
	mut server := &Server{
		db: sqlite.connect('cv.sqlite') or { panic(err) }
		config: config
	}
	server.handle_static(static_dir, true)
	return server
}

pub fn (mut s Server) before_request() {
	// println(s.config.json_parser.get())
}