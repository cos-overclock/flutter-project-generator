
use std::fmt;

use clap::{Parser, ValueEnum};
use dialoguer::{Input, MultiSelect};
use console::{style, Term};

#[derive(ValueEnum, Copy, Clone, Debug)]
enum Feature {
    Database,
    StateManagement,
    DependencyInjection,
    Routing,
    Localization,
    Logging,
    Util,
}

impl fmt::Display for Feature {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Feature::Database => write!(f, "Database"),
            Feature::StateManagement => write!(f, "State Management"),
            Feature::DependencyInjection => write!(f, "Dependency Injection"),
            Feature::Routing => write!(f, "Routing"),
            Feature::Localization => write!(f, "Localization"),
            Feature::Logging => write!(f, "Logging"),
            Feature::Util => write!(f, "Util"),
        }
    }
}

#[derive(Parser, Debug)]
#[command(version, about)]
struct Cli {

    /// Flutter project name
    #[arg(value_parser = app_name_validator)]
    name: Option<String>,

    /// The organization responsible for your new Flutter project
    #[arg(short, long, value_parser = org_validator)]
    org: Option<String>,

    /// Application feature list
    #[arg(short, long)]
    feature: Option<Vec<Feature>>,
}

fn app_name_validator(name: &str) -> Result<String, String> {
    if name.chars().all(|c| c.is_ascii_lowercase() || c == '_') {
        Ok(name.to_string())
    } else {
        Err("Application name should be in lower snake case".to_string())
    }
}

fn org_validator(org: &str) -> Result<String, String> {
    // TODO: add organization validator as reverse domain name notation.
    Ok(org.to_string())
}

fn main() {
    let args = Cli::parse();
    let term = Term::stdout();

    term.clear_screen().unwrap();

    let app_name: String = match args.name {
        Some(name) => name,
        None => input_and_display(&term, "Application Name", app_name_validator),
    };
    println!("Application Name: {}", style(app_name.clone()).cyan().bold());

    let org = match args.org {
        Some(org) => org,
        None => input_and_display(&term, "Organization", org_validator),
    };
    println!("Organization: {}", style(org.clone()).cyan().bold());

    let available_features = vec![
        Feature::Database,
        Feature::StateManagement,
        Feature::DependencyInjection,
        Feature::Routing,
        Feature::Localization,
        Feature::Logging,
        Feature::Util,
    ];
    let selected_features = match args.feature {
        Some(features) => features,
        None =>
        MultiSelect::new()
            .with_prompt("Select Features")
            .items(&available_features)
            .interact()
            .unwrap()
            .into_iter()
            .map(|index| available_features[index])
            .collect()
    };
    term.clear_last_lines(1).unwrap();
    println!(
        "Features: {}",
        selected_features
            .iter()
            .map(|f| format!("{:?}", style(f).cyan().bold()))
            .collect::<Vec<String>>()
            .join(", ")
    );
}


fn input_and_display<F: Fn(&str)-> Result<String, String>>(term: &Term, prompt: &str, validator: F) -> String {
    loop {
        let input: String = match Input::new().with_prompt(prompt).interact_text() {
            Ok(value) => value,
            Err(_) => {
                println!("Failed to read input. Please try again.");
                continue;
            }
        };
        match validator(input.as_str()) {
            Ok(_) => {
                term.clear_last_lines(1).unwrap();
                return input;
            },
            Err(err) => println!("{}", err),
        };
    }
}

