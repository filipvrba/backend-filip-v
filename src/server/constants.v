module server

const(
	port = 8080
	static_dir = 'shared'
	healts = {
		200: Health{ 200, "OK" }
		201: Health{ 201, "Created" }
		403: Health{ status_code: 403, status: "Forbidden" }
		405: Health{ status_code: 405, status: "Method Not Allowed" }
	}
)