module server

import vweb
import rb
import net.http
import net.urllib

[get; "/api/v1/github/access_token"]
pub fn (mut s Server) get_api_github_access_token() vweb.Result {
	client_id := s.query['client_id']
	code := s.query['code']
	database := s.query['database']
	event := rb.Event{name: 'get /api/v1/github/access_token'}

	data := {
		'client_id': client_id,
		'client_secret': s.client_secret(database) or {
			str_err_code := rb.String{err.str()}.sub('^.*code: ', '').to_v()
			err_health := get_err_health(str_err_code)
			event.println(err_health.str())
			return s.json(err_health)
		},
		'code': code,
		'accept': 'json'
	}
	result := http.post_form(gh_access_token_url, data) or {
		event.println(healts[401].str())
		return s.json(healts[401])
	}
	result_body := urllib.query_unescape(result.body) or {""}
	access_token := AccessToken{
		result_body.find_between('access_token=', '&'),
		result_body.find_between('scope=', '&'),
		rb.String{result_body}.sub('^.*token_type=', '').to_v()
	}

	event.println(healts[200].str())
	return s.json(access_token)
}