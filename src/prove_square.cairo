use starknet::ContractAddress;

#[starknet::interface]
trait IProveSquare<TContractState> {
    fn prove_not_square(self: @TContractState, x: felt252, y: felt252) -> felt252;
}

#[starknet::contract]
mod ProveSquare {
    #[storage]
    struct Storage {
    }

    #[abi(embed_v0)]
    impl ProveSquareImpl of super::IProveSquare<ContractState> {
        fn prove_not_square(self: @ContractState, x: felt252, y: felt252) -> felt252 {
            let y_squared = y * y;
            let diff = x - y_squared;
            diff
        }
    }
} 