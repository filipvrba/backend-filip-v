module server

pub fn is_query_valid(query string, keywords []string) bool {
	for keyword in keywords {
		if query.to_lower().index(keyword) or {-1} > -1 {
			return false
		}
	}
	return true
}

pub fn get_err_health(status_code string) Health {
	return Health{status_code.int(), "SQL Error"}
}