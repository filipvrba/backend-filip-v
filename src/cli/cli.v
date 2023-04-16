module cli

pub struct Cli {
pub:
	arguments Arguments = get_arguments()
pub mut:
	config Configuration = get_config()
}
