module server

import vweb

pub fn (mut s Server) health() vweb.Result {
	context := healts[200]
	return s.json(context)
}

[get; "/api/v1"]
pub fn (mut s Server) get_api_database() vweb.Result {
	token := s.query['token']
	database := s.query['database']
	query := s.query['query']

	keywords := [
		"insert into",
		"create table",
		"delete",
		"update"
	]
	if token != host_client {
		return s.json(healts[403])
	}
	if !is_query_valid(query, keywords) {
		return s.json(healts[405])
	}

	context := s.database[database].exec(query)
	return s.json(context)
}

[post; "/api/v1"]
pub fn (mut s Server) post_api_database() vweb.Result {
	header := s.Context.req.header
	token := header.get_custom("Token") or {""}
	database := header.get_custom("Database") or {""}
	query := header.get_custom("Query") or {""}

	if token != host_server {
		return s.json(healts[403])
	}

	keywords := [
		"insert into",
		"create table"
	]
	if is_query_valid(query, keywords) {
		return s.json(healts[405])	
	}

	s.database[database].exec(query)
	return s.json(healts[201])
}