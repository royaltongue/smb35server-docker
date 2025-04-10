
from nintendo.nex import common
from anynet import http
import contextlib


TEMPLATE = open('dashboard.html')

ROW_TEMPLATE = "\t\t\t<tr><td>%i</td><td>%i</td><td>%i</td><td>%s</td></tr>"


class Dashboard:
	def __init__(self, clients, matchmaker):
		self.clients = clients
		self.matchmaker = matchmaker
		
		self.start_time = common.DateTime.now()
	
	async def handle(self, client, request):
		rows = []
		for session in self.matchmaker.sessions.values():
			info = session.session
			rows.append(ROW_TEMPLATE %(
				info.id, info.game_mode, info.num_participants,
				info.started_time
			))
		
		response = http.HTTPResponse(200)
		response.headers["Content-Type"] = "text/html"
		response.text = TEMPLATE %(
			common.DateTime.now(), self.start_time,
			len(self.clients.clients), "\n".join(rows)
		)
		return response


@contextlib.asynccontextmanager
async def serve(host, port, context, clients, matchmaker):
	dashboard = Dashboard(clients, matchmaker)
	async with http.serve(dashboard.handle, host, port, context):
		yield
