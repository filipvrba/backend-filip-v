module server

import vweb
import src.cli

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
