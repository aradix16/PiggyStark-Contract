#[starknet::contract]
pub mod PiggyStark {
    use contracts::interfaces::ipiggystark::IPiggyStark;
    use contracts::structs::piggystructs::Asset;
    use core::num::traits::Zero;
    use starknet::{ContractAddress, get_caller_address};
    use starknet::storage::{Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess, Vec, VecTrait, MutableVecTrait};
    
    #[storage]
    struct Storage {
       owner: ContractAddress,
       // Mapping from user address to the token address they deposited
       user_deposits: Map::<ContractAddress, Vec<(ContractAddress, u256)>>, // Map user address to a Vec of token address, token amount pair
    //    locked_funds: Map::<ContractAddress, Vec<(ContractAddress, u256)>>,
        // deposited_token: Map::<ContractAddress, ContractAddress>,
        // Mapping from (user address, token address) to deposit amount
        // deposit_values: Map::<(ContractAddress, ContractAddress), u256>,
        
    }


    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress){
        self.owner.write(owner);
    }

    #[abi(embed_v0)]
    impl PiggyStarkImpl of IPiggyStark<ContractState> {
        fn deposit(ref self: ContractState, token_address: ContractAddress, amount: u256) {

        }
        fn withdraw(ref self: ContractState, token_address: ContractAddress, amount: u256) {}

       
        fn get_user_assets(self: @ContractState) -> Array<Asset> {
            let caller = get_caller_address();
            let mut assets = ArrayTrait::new();
            let deposits = self.user_deposits.entry(caller);
            let len = deposits.len();
            let mut i: u64 = 0;
            while i != len {
                let (token_address, amount) = deposits.at(i).read();
                assets.append(
                    Asset {
                        token_name: "PIGGY STARK",
                        token_address: token_address,
                        balance: amount,
                    }
                );
                i = i + 1;
            }

            assets
        }


        fn get_token_balance(self: @ContractState, token_address: ContractAddress) {}
    }
}
