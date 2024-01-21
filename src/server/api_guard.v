module server

import vweb
import rb

@[get; "/api/v1/guard"]
pub fn (mut s Server) get_api_database_guard() vweb.Result {
	token := s.query['token']
	database := s.query['database']
	event := rb.Event{name: 'get /api/v1/guard'}

	query := s.get_query_from_token(database, token) or {
		event.println(healts[403].str())
		return s.json(healts[403])
	}

	keywords := [
		"insert into",
		"create table",
		"delete",
		"update"
	]
	if !is_query_valid(query, keywords) {
		event.println(healts[405].str())
		return s.json(healts[405])
	}

	context := unsafe{s.database[database].exec(query) or {
		event.println(get_err_health(err.str()).str())
		return s.json(get_err_health(err.str()))
	}}

	event.println(healts[200].str())
	return s.json(context)
}
