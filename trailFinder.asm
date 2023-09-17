.data
	trail_welcome: .asciiz "Take a stroll along a beautiful trail! (Only if you're in Alameda, \nFremont, Newark, or Dublin.) Enter your zip code:\n"
	mission_peak: .asciiz "Mission Peak is the closest trail to you.\n"
	bay_farm_island: .asciiz "Bay Farm Island Shoreline Trail is the closest trail to you.\n"
	public_shoreline: .asciiz "Public Shoreline Trail is the closest trail to you.\n"
	martin_canyon: .asciiz "Martin Canyon Creek Trail is the closest trail to you.\n"
	coyote_hills: .asciiz "Coyote Hills is the closest trail to you.\n"
	don_edwards: .asciiz "Don Edwards San Francisco Bay National Wildlife Refuge is the closest trail to you.\n"
	lake_elizabeth: .asciiz "Lake Elizabeth Park is the closest trail to you.\n"
	quarry_lake: .asciiz "Quarry Lakes is the closest trail to you.\n"
	not_valid: .asciiz "Sorry, please enter a zip code from Alameda, Fremont, Newark, or Dublin."

.text
finder:
	li $v0, 51				# ask user for ZIP code input with a textbox
	la $a0, trail_welcome
	syscall
	
	move $t0, $a0				# copying input to t0
	
	li $t1, 94555				# loading in valid ZIP codes
	li $t2, 94539
	li $t3, 94538
	li $t4, 94536
	li $t5, 94560
	li $t6, 94568
	li $t7, 94501
	li $t8, 94502
	
	beq $t0, $t1, zip_94555			# jump to certain function based on user's ZIP
	beq $t0, $t2, zip_94539
	beq $t0, $t3, zip_94538
	beq $t0, $t4, zip_94536
	beq $t0, $t5, zip_94560
	beq $t0, $t6, zip_94568
	beq $t0, $t7, zip_94501
	beq $t0, $t8, zip_94502
	
	li $a1, 1				# if user does not put in a valid ZIP code it rejects it
	li $v0, 55
	la $a0, not_valid
	syscall 
	
	li $v0, 10				# exit safely
	syscall
	
zip_94555:
	li $t1, 3755				# load in ZIP input's coordinates
	li $t2, 12208
	
	jal load_coordinates
	
zip_94539:
	li $t1, 3752
	li $t2, 12190
	
	jal load_coordinates
zip_94538:
	li $t1, 3751
	li $t2, 12199
	
	jal load_coordinates
zip_94536:
	li $t1, 3757
	li $t2, 12199
	
	jal load_coordinates
zip_94560:
	li $t1, 3752
	li $t2, 12205
	
	jal load_coordinates

zip_94568:
	li $t1, 3772
	li $t2, 12191
	
	jal load_coordinates

zip_94501:
	li $t1, 3777
	li $t2, 12228
	
	jal load_coordinates

zip_94502:
	li $t1, 3773
	li $t2, 12224
	
	jal load_coordinates
	
load_coordinates:
	li $t3, 3750				# load in trail's coordinates
	li $t4, 12191
	la $a0, mission_peak			# matching coordinates with trail's string
	li $t8, 10000000000000000000000000	# ensuring t7 is set as the min
	jal measure_distance			# jump to measure distance function
	
	li $t3, 3774
	li $t4, 12226
	la $a0, bay_farm_island
	jal measure_distance
	
	li $t3, 3777
	li $t4, 12227
	la $a0, public_shoreline
	jal measure_distance	
	
	li $t3, 3770
	li $t4, 12195
	la $a0, martin_canyon
	jal measure_distance	
	
	li $t3, 3755
	li $t4, 12209
	la $a0, coyote_hills
	jal measure_distance
	
	li $t3, 3753
	li $t4, 12207
	la $a0, don_edwards
	jal measure_distance	
	
	li $t3, 3755
	li $t4, 12197
	la $a0, lake_elizabeth
	jal measure_distance
	
	li $t3, 3758
	li $t4, 12201
	la $a0, quarry_lake
	jal measure_distance
	
	move $a0, $v0				# moving string to a0 so it can print
	li $a1, 1
	li $v0, 55				# printing string in a textbox
	syscall
	
	j main					# jump back to main menu
	
measure_distance:
	sub $t5, $t1, $t3			# N/S coordinate of ZIP - N/S coordinate of trail = a
	sub $t6, $t2, $t4			# W/E coordinate of ZIP - W/E coordinate of trail = b
	mul $t5, $t5, $t5			# a^2
	mul $t6, $t6, $t6			# b^2
	add $t7, $t5, $t6			# a^2+b^2 = t7 (modified distance formula)
	ble $t7, $t8, less_than			# if t7 is less than t8 jump to less than function
	jr $ra					# jump back to load coordinates function

less_than:
	move $t8, $t7				# move t7 to t8 (new minimum)
	move $v0, $a0  				# storing a0 into message
	jr $ra					# jump back to measure distance function
