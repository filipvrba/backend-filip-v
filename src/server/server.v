module server

import vweb
import os
import src.cli

const (
	port = 8080
	static_dir = 'src/public'
	host_client = os.environ()["BEF_CLIENT"]
	host_server = os.environ()["BEF_SERVER"]
)

pub struct Server {
	vweb.Context
pub mut:
	database map[string]Database [vweb_global]
}

pub fn new(config cli.Configuration) {
	
	vweb.run_at(new_server(config), vweb.RunParams{
        port: port
    }) or { panic(err) }
}

fn new_server(config cli.Configuration) &Server {
	
	mut server := &Server{
		database: get_database(config)
	}
	server.handle_static(static_dir, true)
	return server
}
