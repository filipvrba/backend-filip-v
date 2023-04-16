module server

import vweb
import x.json2
import json

pub fn (mut s Server) health() vweb.Result {
	context := Health{ 200, "ok" }
	return s.json(context)
}

[get; "/api/v1/database"]
pub fn (mut s Server) get_api_database() vweb.Result {
	context := s.database["sandbox"].exec("select * from profiles")
	return s.json(context)
}