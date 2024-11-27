export interface Bet {
    id: number;
    bet_id: string;
    bet_type: string;
    name: string;
    image?: string | null;
    category?: string | null;
    description?: string | null;
    is_settled: boolean;
    is_active: boolean;
    deadline: string;
    vote_deadline: string;
    total_money_betted: string;
    yield_strategy_type: number;
    yield_strategy_name?: string | null;
    yield_strategy_symbol?: string | null;
    yield_strategy_address?: string | null;
    reference_price_key?: string | null;
    reference_price?: string | null;
    bet_condition?: number | null;
    bet_token_name: string;
    bet_token_address: string;
    outcome_yes_name: string;
    outcome_yes_bought_amount: string;
    outcome_yes_bought_amount_with_yield: string;
    outcome_no_name: string;
    outcome_no_bought_amount: string;
    outcome_no_bought_amount_with_yield: string;
    winner_outcome?: string | null;
  }