defmodule BlockScoutWeb.BlockView do
  use BlockScoutWeb, :view

  import Math.Enum, only: [mean: 1]

  alias Ecto.Association.NotLoaded
  alias Explorer.Chain
  alias Explorer.Chain.{Block, Wei}
  alias Explorer.Chain.Block.Reward
  alias Explorer.Counters.{BlockBurnedFeeCounter, BlockPriorityFeeCounter}

  @dialyzer :no_match

  def average_gas_price(%Block{transactions: transactions}) do
    average =
      transactions
      |> Enum.map(&Decimal.to_float(Wei.to(&1.gas_price, :gwei)))
      |> mean()
      |> Kernel.||(0)
      |> BlockScoutWeb.Cldr.Number.to_string!()

    unit_text = gettext("Gwei")

    "#{average} #{unit_text}"
  end

  def block_type(%Block{consensus: false, nephews: %NotLoaded{}}), do: "Reorg"
  def block_type(%Block{consensus: false, nephews: []}), do: "Reorg"
  def block_type(%Block{consensus: false}), do: "Uncle"
  def block_type(_block), do: "Block"

  @doc """
  Work-around for spec issue in `Cldr.Unit.to_string!/1`
  """
  def cldr_unit_to_string!(unit) do
    # We do this to trick Dialyzer to not complain about non-local returns caused by bug in Cldr.Unit.to_string! spec
    case :erlang.phash2(1, 1) do
      0 ->
        BlockScoutWeb.Cldr.Unit.to_string!(unit)

      1 ->
        # does not occur
        ""
    end
  end

  def formatted_gas(gas, format \\ []) do
    BlockScoutWeb.Cldr.Number.to_string!(gas, format)
  end

  def formatted_timestamp(%Block{timestamp: timestamp}) do
    Timex.format!(timestamp, "%b-%d-%Y %H:%M:%S %p %Z", :strftime)
  end

  def show_reward?([]), do: false
  def show_reward?(_), do: true

  def block_reward_text(%Reward{address_hash: beneficiary_address, address_type: :validator}, block_miner_address) do
    if Application.get_env(:explorer, Explorer.Chain.Block.Reward, %{})[:keys_manager_contract_address] do
      %{payout_key: block_miner_payout_address} = Reward.get_validator_payout_key_by_mining_from_db(block_miner_address)

      if beneficiary_address == block_miner_payout_address do
        gettext("Miner Reward")
      else
        gettext("Chore Reward")
      end
    else
      gettext("Miner Reward")
    end
  end

  def block_reward_text(%Reward{address_type: :emission_funds}, _block_miner_address) do
    gettext("Emission Reward")
  end

  def block_reward_text(%Reward{address_type: :uncle}, _block_miner_address) do
    gettext("Uncle Reward")
  end

  def combined_rewards_value(block) do
    block
    |> Chain.block_combined_rewards()
    |> format_wei_value(:ether)
  end

  def miner_logo(address) do
    cond do 
      Base.encode16(address.miner_hash.bytes) == "AA84378FA41DA83A9B6523BA46E45A664FBEBFC8" -> "/images/max_planck.png"
      Base.encode16(address.miner_hash.bytes) == "8DE281F47B137979E55B6CEA598179737574C774" -> "/images/Georgia_Technology.png"
      Base.encode16(address.miner_hash.bytes) == "841C25A1B2BA723591C14636DC13E4DEEB65A79B" -> "/images/Faculty_Sciences.png"
      Base.encode16(address.miner_hash.bytes) == "1EF319DB1930E3420FCFF90C376D9CF515B34876" -> "/images/ETH_Library.png"
      Base.encode16(address.miner_hash.bytes) == "A59DDC352A6521Ef4Cb338dAe4b1B2A609233194" -> "/images/University_College_London.png"
      Base.encode16(address.miner_hash.bytes) == "2FA6F57FF56A1DA41FB7C6A176F630641E20CD53" -> "/images/Carnegie_Mellon_University.png"
      Base.encode16(address.miner_hash.bytes) == "E659BC6A60BA2091C08F7DF623BA6057349B6980" -> "/images/IT_University_of_Copenhagen.png"
      Base.encode16(address.miner_hash.bytes) == "6E7215893131BF41AF6256B5CF0BD61BD631B796" -> "/images/University_of_Nicosia.png"
      Base.encode16(address.miner_hash.bytes) == "008D897EDCFAA9BE1E4ACFBD4D8659BB0D33F1A0" -> "/images/ZIBS.png"
      Base.encode16(address.miner_hash.bytes) == "93DA5507A26090448A03FC1F77E1C7DA20A24292" -> "/images/University_of_Johannesburg.png"
      Base.encode16(address.miner_hash.bytes) == "F0F659E9EC6B4358A8D7FBA6A0CA79BAADE10552" -> "/images/Institute_for_Internet_Security.png"
      Base.encode16(address.miner_hash.bytes) == "DDDCB89201F5A24891610B033351A5408A081F98" -> "/images/University_of_Kassel.png"
      Base.encode16(address.miner_hash.bytes) == "A5F9BFD31ADE231FE768CDC65567E0D60EEB556A" -> "/images/University_of_Timisoara.png"
      Base.encode16(address.miner_hash.bytes) == "738E6E88D4415E2E5075E15CC24FD9416F1C89C3" -> "/images/Furtwangen_University.png"
      Base.encode16(address.miner_hash.bytes) == "8823A9E567BAC419C394C646E1D2F0929D2039EE" -> "/images/Karlsruhe_Institute_of_Technology.png"
      Base.encode16(address.miner_hash.bytes) == "61AA0B556E23A28B1C634B97307C20E048C2F116" -> "/images/Simon_Business_School.png"
      Base.encode16(address.miner_hash.bytes) == "63FB9AAB8BCD1837D8D1A5318B73B1D4ADC4FC6A" -> "/images/Fraunhofer_Institute.png"
      Base.encode16(address.miner_hash.bytes) == "37D1B7A3EEC870E593C32D790E52B89908CA90F1" -> "/images/University_of_Geneva.png"
      Base.encode16(address.miner_hash.bytes) == "AA4870919390F1026C17651B4F8F29CBC50FD789" -> "/images/Instituto_Gulbenkian.png"
      Base.encode16(address.miner_hash.bytes) == "2EAEA0039C54F63CC344C3EAACFE69421C7EE785" -> "/images/Bogazici_University.png"
      Base.encode16(address.miner_hash.bytes) == "F824831114BE0C8B3819077C8FD514474672FC8B" -> "/images/School_of_Economics_Sarajevo.png"
      Base.encode16(address.miner_hash.bytes) == "D96C56AB670B8DBB213CF0331433D47221F169C5" -> "/images/Weizenbaum.png"
      Base.encode16(address.miner_hash.bytes) == "EE4308865D6B23AFD70B7108A35DEA8D6481BBC2" -> "/images/The_Open_University.png"
      Base.encode16(address.miner_hash.bytes) == "C636283C5D8D1F11FA51FA04B5412517C4DE7AC9" -> "/images/Chiba_Institute_of_Technology.png"
      Base.encode16(address.miner_hash.bytes) == "9CA00A5B1B61157D5D75F0C41CDDB157DD050D71" -> "/images/University_of_Technikum_Wien.png"
      Base.encode16(address.miner_hash.bytes) == "94813130274F6C85ED658CCD653E892744127898" -> "/images/Technical_University_of_Munich.png"
      Base.encode16(address.miner_hash.bytes) == "FFC32FB02C5D227480246951A75EB00B18DF3F1F" -> "/images/Gakushuin_University.png"
      Base.encode16(address.miner_hash.bytes) == "5385E5F2EECA3AA0D4671D166F0EBB05BA20D710" -> "/images/Goethe_University_Frankfurt.png"
      Base.encode16(address.miner_hash.bytes) == "65DC5CE59B15250B8ACDD90C3C171E2E7F05D9B7" -> "/images/University_of_West_Attica.png"
      Base.encode16(address.miner_hash.bytes) == "99451B8834642914F3A77089FAB9E2EE4AE66085" -> "/images/University_of_North_Florida.png"
      Base.encode16(address.miner_hash.bytes) == "67C7448172CF110DC7B0C44A40027EF27F037C60" -> "/images/Auckland_University_of_Technology.png"
      Base.encode16(address.miner_hash.bytes) == "DE564BF2D9885FBFDE5556F2CA4A72F1FC0AC307" -> "/images/National_Defence_University.png"
      Base.encode16(address.miner_hash.bytes) == "28AFCDEB1BEBD091B4526F278CB588AE6637A622" -> "/images/Wroclaw_University.png"
      Base.encode16(address.miner_hash.bytes) == "28570E7ACFF6C62270E08B639CC7724DD728035F" -> "/images/University_di_Torino.png"
      Base.encode16(address.miner_hash.bytes) == "3869BC0FBE9E69EC32DBB66E1D3A2BD74399D273" -> "/images/Fairfield_Dolan.png"
      Base.encode16(address.miner_hash.bytes) == "C604FFA8ADE14DC9A22B6B19BDFC07E489156E53" -> "/images/AGAP_Institute.png"
      Base.encode16(address.miner_hash.bytes) == "A2A417F9133667A24A8BE4FAC41F3E3534842E20" -> "/images/Ludwig_Maximilians_Universität_Munich.png"
      Base.encode16(address.miner_hash.bytes) == "55299871982DF69FA3D2B3770E25A33CA4FFD8FD" -> "/images/Faculty_of_Organization_and_Informatics.png"
      Base.encode16(address.miner_hash.bytes) == "548CC5805B67C181913CC88FDE3A70E37A0718CE" -> "/images/West_University_of_Timișoara.png"
      Base.encode16(address.miner_hash.bytes) == "6ED81C13B52CB7E64CA29BBC726B1B2C0B685181" -> "/images/University_of_Ansbach.png"
      Base.encode16(address.miner_hash.bytes) == "C9D13D9B510B73C63865EC1A19DE5462C8A4E053" -> "/images/UZH_Blockchain_Center.png"
      Base.encode16(address.miner_hash.bytes) == "BF46DF3EE75F8AABED8A1954A386FF50880FE1D3" -> "/images/Centre_for_Distributed_Ledger_Technologies.png"
      Base.encode16(address.miner_hash.bytes) == "9B522BCA5CAFFD5684D8498E04F1E3DC4735D109" -> "/images/Ferdinand_Institute.png"
      Base.encode16(address.miner_hash.bytes) == "0FC31D48C40D652F32322D3D89C5D8A67B37B3BE" -> "/images/Cyril _University.png"
      Base.encode16(address.miner_hash.bytes) == "E845CCC925B44C2F50CE8E67103DFE840EFA8F89" -> "/images/University_of_Split.png"
      Base.encode16(address.miner_hash.bytes) == "12C5FF506FFACF2056F04F3889F45E4187DF98F2" -> "/images/Universidade_Parana.png"
      Base.encode16(address.miner_hash.bytes) == "8FB88D387A757F22F54411D822DD1D3557B505CA" -> "/images/Mendel_University.png"
      Base.encode16(address.miner_hash.bytes) == "643950742EC05FB0EBE2AF75AF99D811E0C255F2" -> "/images/ircelyon.png"
      true -> "/images/bloxberg_Not_found_logo.png"
    end
  end
end
