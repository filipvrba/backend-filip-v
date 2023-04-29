# Backend-Filip
Je CLI aplikace napsaná ve V jazyce. Jedná se o backend, která přístupňuje
několik předem definovaných databází pomocí REST API.
Je tedy odhlehčenou aplikací pro manipulaci a nevyžaduje komplikované
endpointy. Skoro vše se provádí přes jeden endpoint, se kterým
se dá manipulovat celkové se všemi databázemi. Databáze jsou SQLite, které
jsou chráněny tokeny.

## Usage
Aplikace má název **bef** pro spuštění CLI.
Při spuštění serveru se definuje kolik databází
má aplikace vytvořit pro manipulaci přes REST API.

Zde jsou uvedeny možnosti použití aplikace:
```txt
server LENGTH               	Starts a web server with a defined
								value to create many databases
								(The LENGTH value has a range from 1 to 255).           
-gt LENGTH, --get-token LENGTH  Generates a token with a defined length.
```

## API
K přístupu k API, ze používají 3 endpointy.
První z nich je nejzákladnější pro manipulaci s DB.
Umožňuje tyto metody *GET, POST, PATCH a DELETE*.
Zbylé endpointy mají jen metodu *GET*.

Endpoints:
1. **/api/v1**
	- GET:
		Klasické URL s parametry.
		```txt
		<URL>/api/v1?token=<CLIENT_TOKEN>&database=<NAME>&query=<SQL_QUERY>
		```
	- POST, PATCH a DELETE:
		Posílání dat se provádí přes hlavičku.
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

## SQLite
Automatické generování tabulek:
- Authorization
	- id int (Automatické)
	- client_secret string
	- client_token string (Automaticky generuje 32 znakový token.)
	- server_token string (Automaticky generuje 64 znakový token.)
- Guard
	- id int (Automatické)
	- query string
	- token string

1. Authorization: Je pro autorizaci DB a GitHubu.
	- client_token: Přistupuje k DB pomocí SELECT příkazu.
	- server_token: Přistupuje k DB pomocí POST, PATCH a DELETE příkazu.
2. Guard: Je pro omezení přístupnosti k DB pomocí předem definovaného příkazu (používá jen SELECT).

## Dev Notes
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