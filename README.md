# Spacecraft-Swarm-Simulator
Spacecraft Swarm Simulator is a flexible simulation tool to analyze the high and low-level control of a set of spacecraft under a defined relative dynamics.

The tool is based on a set of modules, managed by the main program file (SwarmSimulator.m) which expresses the flow of the program. The simulation parameters are loaded in SSlo_LoadOptions. Then the swarm model is loaded in SSis_InitializeSimulator, where the size and spacecraft separation is defined. Then the main process of the simulator is launched, where the controllers lead the spacecraft to their desired positions. Finally, the results are processed, showing the required outputs. 

SwarmSimulator is designed to be flexible. That is the reason why the spacecraft modeling class (agents) allows to include a wide set of actuator and controller options which can be increased. Also, the space dynamics model only requires a state vector and relative dynamics. Therefore many dynamics models can be implemented. Finally, even the controllers can be changed to test different scenarios. The included ones are Mario Coppola's et al high-level control (DSSA) and a simple PID low-level controller executing the actions of DSSA. Nevertheless, changing the low-level control file and a line in the main process will result in the use of a whole different controller only requiring that state vector format is respected.

This project was developed as the author's master thesis project at Delft University of Technology's Aerospace Faculty (Space Systems Engineering department). If you are planning on using it cite me with:

http://resolver.tudelft.nl/uuid:ebce23c1-7b05-4346-b552-0f962d07dfcf

In that link, you can also find detailed notes on how the simulator and its models work as well as flow diagrams and the philosophy behind this simulator.

Enjoy using it!
