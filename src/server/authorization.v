module server

pub fn (mut s Server) client_token(db_name string) string {
	select_auth := sql s.database[db_name].sqlite {
		select from Authorization
	} or { panic(err) }[0]

	return select_auth.client_token
}

pub fn (mut s Server) server_token(db_name string) string {
	select_auth := sql s.database[db_name].sqlite {
		select from Authorization
	} or { panic(err) }[0]

	return select_auth.server_token
}

pub fn (mut s Server) get_query_from_token(db_name string, token string) !string {
	select_guard := sql s.database[db_name].sqlite {
		select from Guard where token == token
	} or { error(err) }

	if select_guard.len > 0 {
		return select_guard[0].query
	}
	else {
		return error("No guard was found.")
	}
}

pub fn (mut s Server) client_secret(db_name string) string {
	select_auth := sql s.database[db_name].sqlite {
		select from Authorization
	} or { panic(err) }[0]

	return select_auth.client_secret
}