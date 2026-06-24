/*! \file Version_History.c */

/*!
\page History

\section History

\par V0.00
	\arg First draft version

\par V1.00
	\arg First functional version. Added inline comments.

\par V1.01
	\arg Removed the input Unit in the MBT_client. Make it possible to communicate to many units in the same server in a simple way.
	\arg Added documentation for the client.

\par V1.02
	\arg Updated documentation.

\par V1.03
	\arg Added functionality for handling 4 byte variables.

\par V1.10
	\arg release version including 4 byte holding registers.
	\arg bugfix for client which previously used up all idents if server was unavailable.

\par V1.11
	\arg BRSE_MB_Server function has been rewritten to improve performance. Requests from each client are now responded to in the same cycle. 
	\arg That brings the execution time to depend very much on the server load, i.e. frequency of client requests

\par V1.12
	\arg Bugfixes:
	\arg If timeout occurs during TcpRecv, the FUB is only aborted if tcpERR_NO_DATA is the status.
	\arg The timeout in TcpClient has been removed, since it was unnecessary and aborted TcpClient during execution.
	\arg On the server side, if error code tcpERR_SENTLEN is received, it retries sending instead of disconnecting the client.

\par V1.13
	\arg New feature: ConnectionMode for client. Default behaviour: When the queue is empty, the connection is closed. Optional behaviour: the connection statys open.
	\arg Bugfixed: Stability improvements in both server and clients. Reconneciton-patterns and error behaviours have been revised.
\par V1.14
	\arg MAX_CLIENTS has been set up to 10, as this is above the socket limit for SGC CPUs.
	\arg BRSE_MBT_Server / MBT_Client : new input \b SocketTimeout which specifies the time for the system to close down the socket (see also AsTCP linger set) in seconds.
	\arg MBT_Client : New input \b ConnectionTimeout, has replaced the input \b ConnectionMode, and now specifies the time until an empty queue closes the connection to the server.
	\arg MBT_Client : Changed behaviour when a server does not respond to a request. Before, the client would retry to send the request, but now the client just passes on an error message to the corresponding BRSE_MB block.
	\arg Added dependency to the brsystem library, which reads out the cycle time of the task. In this way, the MBT_Client is no longer dependent on the \b CycleTime input. It has therefore been removed.
\par V1.15
	\arg MBT_Client, BRSE_MBT_Server : Changed behaviour of the SocketTimeout input when it is zero. Value Zero now disables lingering, the connection closes immediately.
\par V1.20
	\arg BRSE_MBT_Server : Bugfix for closing connections. There was a problem when closing many clients simultaneously which left sockets open.
	The cause of the error was that only one instance of the tcpclose function was used. 
	Now there are BRSE_MBT_MAX_CLIENTS instances of TcpClose, which solves this error. 
*/
