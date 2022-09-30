#! /bin/sh

# Retreive all installed applications
for application in $(ls -d */)
do
	echo "Starting auto-update for $application."

	# Check if should skip this one or not
	should_ignore=$(find $application -type f -name '.ignore-update' | wc -l)
	
	if [ "$should_ignore" -gt 0 ]
	then
		echo "Skipping auto-update."
		echo
	else
		config_file=$(ls $application/*.yml)

		echo "Pulling images from repository"
		docker compose -f "$config_file" pull 
		echo

		echo "Restarting containers"
		docker compose -f "$config_file" up -d
		echo
	fi
done
