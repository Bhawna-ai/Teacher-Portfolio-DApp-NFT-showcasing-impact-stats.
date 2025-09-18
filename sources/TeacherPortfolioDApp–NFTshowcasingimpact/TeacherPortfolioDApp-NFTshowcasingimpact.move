module MyModule::TeacherPortfolio {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a Teacher's Portfolio NFT with impact stats
    struct TeacherPortfolio has store, key {
        teacher_name: vector<u8>,        // Teacher's name
        students_taught: u64,            // Total students taught
        years_experience: u64,           // Years of teaching experience
        achievement_points: u64,         // Achievement/impact points
        portfolio_value: u64,            // Economic value of the portfolio
    }

    /// Function to create a new teacher portfolio NFT
    public fun create_portfolio(
        teacher: &signer, 
        name: vector<u8>,
        students: u64,
        experience: u64,
        points: u64
    ) {
        let portfolio = TeacherPortfolio {
            teacher_name: name,
            students_taught: students,
            years_experience: experience,
            achievement_points: points,
            portfolio_value: 0,
        };
        move_to(teacher, portfolio);
    }

    /// Function to sponsor/fund a teacher's portfolio by contributing tokens
    public fun sponsor_portfolio(
        sponsor: &signer, 
        teacher_address: address, 
        amount: u64
    ) acquires TeacherPortfolio {
        let portfolio = borrow_global_mut<TeacherPortfolio>(teacher_address);

        // Transfer the sponsorship from sponsor to teacher
        let sponsorship = coin::withdraw<AptosCoin>(sponsor, amount);
        coin::deposit<AptosCoin>(teacher_address, sponsorship);

        // Update the portfolio value
        portfolio.portfolio_value = portfolio.portfolio_value + amount;
    }
}