module server

pub struct Health {
	status_code int
	status string
}

pub struct Authorization {
	id int @[primary; sql: serial]
	client_secret string
	client_token string
	server_token string
}

pub struct Guard {
	id int @[primary; sql: serial]
	query string
	token string
}

pub struct AccessToken {
	access_token string
	scope 		 string
	token_type 	 string
}
