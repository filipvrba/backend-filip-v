module server

import vweb
import rb

pub fn (mut s Server) health() vweb.Result {
	rb.Event{name: 'health'}.println(healts[200].str())
	return s.json(healts[200])
}

[options; "/api/v1"]
pub fn (mut s Server) options_api_database() vweb.Result {
	s.add_header("Access-Control-Allow-Methods", "GET, POST, DELETE, PATCH")
	s.add_header("Access-Control-Allow-Headers", "Token, Database, Query")
	rb.Event{name: 'options /api/v1'}.println(healts[200].str())
	return s.json(healts[200])
}

[get; "/api/v1"]
pub fn (mut s Server) get_api_database() vweb.Result {
	token := s.query['token']
	database := s.query['database']
	query := s.query['query']
	event := rb.Event{name: 'get /api/v1'}

	keywords := [
		"insert into",
		"create table",
		"delete",
		"update"
	]
	if token != s.client_token(database)
	or {
		str_err_code := rb.String{err.str()}.sub('^.*code: ', '').to_v()
		err_health := get_err_health(str_err_code)
		event.println(err_health.str())
		return s.json(err_health)
	} {
		event.println(healts[403].str())
		return s.json(healts[403])
	}
	if !is_query_valid(query, keywords) {
		event.println(healts[405].str())
		return s.json(healts[405])
	}

	context := s.database[database].exec(query) or {
		event.println(get_err_health(err.str()).str())
		return s.json(get_err_health(err.str()))
	}
	
	event.println(healts[200].str())
	return s.json(context)
}

[post; "/api/v1"]
pub fn (mut s Server) post_api_database() vweb.Result {
	header := s.Context.req.header
	token := header.get_custom("Token") or {""}
	database := header.get_custom("Database") or {""}
	query := header.get_custom("Query") or {""}
	event := rb.Event{name: 'post /api/v1'}

	if token != s.server_token(database) or {
		str_err_code := rb.String{err.str()}.sub('^.*code: ', '').to_v()
		err_health := get_err_health(str_err_code)
		event.println(err_health.str())
		return s.json(err_health)
	} {
		event.println(healts[403].str())
		return s.json(healts[403])
	}

	keywords := [
		"insert into",
		"create table"
	]
	if is_query_valid(query, keywords) {
		event.println(healts[405].str())
		return s.json(healts[405])	
	}

	s.database[database].exec(query) or {
		event.println(get_err_health(err.str()).str())
		return s.json(get_err_health(err.str()))
	}
	event.println(healts[201].str())
	return s.json(healts[201])
}

[delete; "/api/v1"]
pub fn (mut s Server) delete_api_database() vweb.Result {
	header := s.Context.req.header
	token := header.get_custom("Token") or {""}
	database := header.get_custom("Database") or {""}
	query := header.get_custom("Query") or {""}
	event := rb.Event{name: 'delete /api/v1'}

	if token != s.server_token(database) or {
		str_err_code := rb.String{err.str()}.sub('^.*code: ', '').to_v()
		err_health := get_err_health(str_err_code)
		event.println(err_health.str())
		return s.json(err_health)
	} {
		event.println(healts[403].str())
		return s.json(healts[403])
	}

	keywords := [
		"delete",
	]
	if is_query_valid(query, keywords) {
		event.println(healts[405].str())
		return s.json(healts[405])
	}

	s.database[database].exec(query) or {
		event.println(get_err_health(err.str()).str())
		return s.json(get_err_health(err.str()))
	}
	event.println(healts[200].str())
	return s.json(healts[200])
}

[patch; "/api/v1"]
pub fn (mut s Server) patch_api_database() vweb.Result {
header := s.Context.req.header
	token := header.get_custom("Token") or {""}
	database := header.get_custom("Database") or {""}
	query := header.get_custom("Query") or {""}
	event := rb.Event{name: 'patch /api/v1'}

	if token != s.server_token(database) or {
		str_err_code := rb.String{err.str()}.sub('^.*code: ', '').to_v()
		err_health := get_err_health(str_err_code)
		event.println(err_health.str())
		return s.json(err_health)
	} {
		event.println(healts[403].str())
		return s.json(healts[403])
	}

	keywords := [
		"update",
	]
	if is_query_valid(query, keywords) {
		event.println(healts[405].str())
		return s.json(healts[405])
	}

	s.database[database].exec(query) or {
		event.println(get_err_health(err.str()).str())
		return s.json(get_err_health(err.str()))
	}
	event.println(healts[200].str())
	return s.json(healts[200])
}