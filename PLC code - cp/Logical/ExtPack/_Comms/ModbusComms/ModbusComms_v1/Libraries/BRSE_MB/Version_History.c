/*!
\page History

\section History

\par V0.00
	\arg First draft version

\par V1.00
	\arg First functional version. Added inline comments.

\par V1.01
	\arg Added the input Unit in the client requests. Make it possible to communicate to many units in the same server in a simple way.
	\arg Added documentation for the client.

\par V1.02
	\arg Updated documentation.

\par V1.03
	\arg Added functionality for handling 4 byte variables.
	
\par V1.10
	\arg Release version for handling 4 byte holding registers

\par V1.11
	\arg Bugfix for writing multiple holding registers 4 byte. the last INT was copied in the wrong way.

\par V1.12
	\arg Bugfixes:
	\arg Allocation functions, if allocation failed, write to logbook and don't memset.
	\arg WriteHoldingRegister, 4WriteByteHoldingRegisters, WriteCoils buffer lengths were 1 byte too long.
	\arg Client functions check if the queue is alive while waiting for answers, returning error codes if the queue died.

\par V1.13
	\arg Minor change in the poll macro (client). Previously the condition to execute was (cycleCounter%pollCycles==0), now it's cycleCounter>=pollCycles (cycleCounter is reset when command is executed).

\par V1.14
	\arg Pagefault when writing to a single holding register when this was mapped as a 4-byte value has been fixed. Now
	an ILLEGAL_DATA_ADDRESS is returned if a 4byte value is mapped on that modbus reference.
	\arg All function blocks with an \b Execute input have been changed so that the execute input is edge sensitive (previously,
	the input was handled rather as an \b Enable input)
	\arg MB_QUEUE_SIZE has been set up to 50, it seems unlikely to have more simultaneous function calls than this at the moment.
	\arg Added dependency to the brsystem library, which reads out the cycle time of the task. The inputs of the functions have therefore changed from \b Poll/PushCycles to \b Poll/PushInterval, which you specify in ms.

\par V1.15
	\arg Corrected status bits from push and poll functions.
	
\par V1.16
	\arg MB_AllocClient : Changed return value to always return the internal address, even though allocation has already been performed.
	\arg Added extra information on the Error_Number page
	\arg Added the ModbusUDP adapter library BRSE_MBU to the documentation
*/
