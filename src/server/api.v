module server

import vweb

pub fn (mut s Server) health() vweb.Result {
	context := Health{ 200, "ok" }
	return s.json(context)
}