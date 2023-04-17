module server

import vweb

pub fn (mut s Server) health() vweb.Result {
	context := Health{ 200, "ok" }
	return s.json(context)
}

[get; "/api/v1"]
pub fn (mut s Server) get_api_database() vweb.Result {
	context := s.database["sandbox"].exec("select * from profiles")
	return s.json(context)
}