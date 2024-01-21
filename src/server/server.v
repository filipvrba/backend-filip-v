module server

import vweb

pub struct Server {
	vweb.Context
pub mut:
	database map[string]Database @[vweb_global]
}

pub fn new(length u8) {
	
	vweb.run_at(new_server(length), vweb.RunParams{
        port: port
    }) or { panic(err) }
}

fn new_server(length u8) &Server {
	mut server := &Server{
		database: get_database(length)
	}
	return server
}

pub fn (mut s Server) before_request() {
    s.add_header("Access-Control-Allow-Origin", "*")
}
