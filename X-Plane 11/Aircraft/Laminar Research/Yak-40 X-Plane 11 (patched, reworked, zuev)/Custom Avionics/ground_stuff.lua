-- this is ground stuff logic

defineProperty("local_vx", globalPropertyd("sim/flightmodel/position/local_vx"))   -- local_x
defineProperty("local_vy", globalPropertyd("sim/flightmodel/position/local_vy"))   -- local_y
defineProperty("local_vz", globalPropertyd("sim/flightmodel/position/local_vz"))   -- local_z

defineProperty("rotate_yaw", globalPropertyd("sim/flightmodel/position/R"))   -- rotation speed
defineProperty("rotate_pitch", globalPropertyd("sim/flightmodel/position/Q"))   -- rotation speed
defineProperty("rotate_roll", globalPropertyd("sim/flightmodel/position/P"))   -- rotation speed

defineProperty("true_course", globalPropertyd("sim/flightmodel/position/psi"))   -- rotation

--[[
sim/operation/override/override_planepath
sim/flightmodel/ground/surface_texture_type	int	y	enum tbd - writable only with	override_groundplane
sim/flightmodel/ground/plugin_ground_center	float[3]	y	meters	Location of a pt on the ground in local corods
sim/flightmodel/ground/plugin_ground_slope_normal	float[3]	y	vector	Normal vector of the terrain (must be normalized)
sim/flightmodel/ground/plugin_ground_terrain_velocity	float[3]	y	m/s 	speed of deck moving under us (this is a velocity vector)
sim/flightmodel/position/local_x	double	y	meters	The location of the plane in OpenGL coordinates
sim/flightmodel/position/local_y	double	y	meters	The location of the plane in OpenGL coordinates
sim/flightmodel/position/local_z	double	y	meters	The location of the plane in OpenGL coordinates

sim/flightmodel/position/theta	float	y	degrees	The pitch relative to the plane normal to the Y axis in degrees
sim/flightmodel/position/phi	float	y	degrees	The roll of the aircraft in degrees
sim/flightmodel/position/psi	float	y	degrees	The true heading of the aircraft in degrees from the Z axis

sim/flightmodel/position/local_vx	float	y	mtr/sec	The velocity in local OGL coordinates
sim/flightmodel/position/local_vy	float	y	mtr/sec	The velocity in local OGL coordinates
sim/flightmodel/position/local_vz	float	y	mtr/sec	The velocity in local OGL coordinates
sim/flightmodel/position/local_ax	float	y	mtr/sec2	The acceleration in local OGL coordinates
sim/flightmodel/position/local_ay	float	y	mtr/sec2	The acceleration in local OGL coordinates
sim/flightmodel/position/local_az	float	y	mtr/sec2	The acceleration in local OGL coordinates

sim/flightmodel/position/P	float	y	deg/sec	The roll rotation rates (relative to the flight)
sim/flightmodel/position/Q	float	y	deg/sec	The pitch rotation rates (relative to the flight)
sim/flightmodel/position/R	float	y	deg/sec	The yaw rotation rates (relative to the flight)

--]]

local SPEED = 0 -- speed of tow. positive = forward.

function update()
	
	-- calculate movement of the plane, according to its course
	local course = math.rad(get(true_course)) -- true course in radians
	local to_North = SPEED * math.cos(course)
	local to_East = SPEED * math.sin(course)
	
	--set(local_vx, to_East) -- to the east
	--set(local_vz, -to_North) -- to the south. negative to the north.
	--set(local_vy, 0) -- to the sky :)
	--set(rotate_yaw, 0) -- rotation of the plane
	--set(rotate_pitch, 0) -- rotation of the plane. block pitch when tow
	--set(rotate_roll, 0) -- rotation of the plane









end