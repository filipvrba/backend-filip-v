# Backend-Filip
This is a CLI application written in V language. It is a backend that provides access to several pre-defined databases through a REST API. It is a lightweight application for manipulation and does not require complicated endpoints. Almost everything is done through one endpoint, with which all databases can be manipulated. The databases are SQLite, which are protected by tokens.

### Content
- [1 Usage](#1-usage)
- [2 API](#2-api)
- [3 SQLite](#3-sqlite)
- [4 Example](#4-example)
- [5 Dev Notes](#5-dev-notes)
- [6 Contributors](#6-contributors)

## 1 Usage
The application is named bef for CLI execution. When starting the server, the number of databases that the application will create for manipulation through the REST API is defined.

Here are the options for using the application:
```txt
server LENGTH               	Starts a web server with a defined
								value to create many databases
								(The LENGTH value has a range from 1 to 255).           
-gt LENGTH, --get-token LENGTH  Generates a token with a defined length.
```

> ### Info
> Never publish tokens or put them in more accessible places!

## 2 API
To access the API, 3 endpoints are used. The first is the most basic for manipulating the DB. It allows these methods GET, POST, PATCH, and DELETE. The remaining endpoints have only the GET method.

Endpoints:
1. **/api/v1**
	- GET:
		Classic URL with parameters.
		```txt
		<URL>/api/v1?token=<CLIENT_TOKEN>&database=<NAME>&query=<SQL_QUERY>
		```
	- POST, PATCH and DELETE:
		Data are sent through the header.
		```txt
		<URL>
		-H "Token: <SERVER_TOKEN>"
		-H "Database: <NAME>"
		-H "Query: <SQL_QUERY>"
		```

2. **/api/v1/guard**
	- GET:
		```txt
		<URL>/api/v1/guard?token=<GUARD_TOKEN>&database=<NAME>
		```

3. **/api/v1/github/access_token**
	- GET:
		```txt
		<URL>/github/access_token?client_id=<APP_ID_GITHUB>" +
		"&database=<NAME>&code=<GITHUB_AUTH_CODE>&scope=<GITHUB_SCOPE>"
		```

## 3 SQLite
Automatic table generation:
- **Authorization**
	- **id** *int (Automatic)*
	- **client_secret** *string*
	- **client_token** *string (Automatically generates a 32-character token.)*
	- **server_token** *string (Automatically generates a 64-character token.)*
- **Guard**
	- **id** *int (Automatic)*
	- **query** *string*
	- **token** *string*

1. Authorization: Is for DB and GitHub authorization.
	- client_token: Accesses the DB using SELECT command.
	- server_token: Accesses the DB using POST, PATCH, and DELETE commands.
2. Guard: Is for limiting access to the DB using a predefined command ***(uses only SELECT)***.

## 4 Example
Here are examples of using BEF api, which are accessed via frontend or cli application.

- [DragonRuby-Egg (UI)](https://github.com/filipvrba/dragonruby-egg-ui-rjs)
- [DragonRuby-Egg (CLI)](https://github.com/filipvrba/dragonruby-egg-rb)

## 5 Dev Notes
Write notes here, for the development of this project.

*Pseudocode:*
```txt
http -> /api/v1/database

	get -> token/database/query
		= result values from db
	post | delete | patch ->
		body
			- token
			- database
			- query
		= result mesage
=== method ===
[x] fn get_api_database
[x] fn post_api_database
[x] fn delete_api_database
[x] fn patch_api_database
```

*Logic for getting the column name into **exec(...)** function was added to db.sqlite module:*
```v
// 84
pub struct Row {
pub mut:
	cols []string
	vals []string
}
// 90
// ...
// 230
col := unsafe { &char(C.sqlite3_column_name(stmt, i)) }
if col == &char(0) {
	row.cols << ''
} else {
	row.cols << unsafe { tos_clone(col) }
}
// 237
```

## 6 Contributors
- [Filip Vrba](https://github.com/filipvrba) - creator and maintainer