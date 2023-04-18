module server

pub fn is_query_valid(query string, keywords []string) bool {
	for keyword in keywords {
		if query.to_lower().index(keyword) or {-1} > -1 {
			return false
		}
	}
	return true
}