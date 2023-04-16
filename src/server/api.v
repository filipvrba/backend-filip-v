module server

import vweb

pub struct Health {
	status_code int
	status string
}

pub fn (mut s Server) health() vweb.Result {
	context := Health{ 200, "ok" }
	return s.json(context)
}