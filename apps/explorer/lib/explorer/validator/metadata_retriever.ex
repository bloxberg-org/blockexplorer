defmodule Explorer.Validator.MetadataRetriever do
  @moduledoc """
  Consults the configured smart contracts to fetch the valivators' metadata
  """

  alias Explorer.SmartContract.Reader

  def fetch_data do
    fetch_validators_list()
    |> Enum.map(fn validator ->
      validator
      |> fetch_validator_metadata
      |> translate_metadata
      |> Map.merge(%{address_hash: validator, primary: true})
    end)
  end

  def fetch_validators_list do
    # b7ab4db5 = keccak256(getValidators())
    # 9fa2c72da17544f5be0e5079da48f23aee458f3ce0ccef3b51240d619e01788c = keccak256(getValidators)
    case Reader.query_contract(
           config(:validators_contract_address),
           contract_abi("validators.json"),
           %{
             "b7ab4db5" => []
           },
           false
         ) do
      %{"b7ab4db5" => {:ok, [validators]}} -> validators
      _ -> []
    end
  end

  defp fetch_validator_metadata(validator_address) do
    # fa52c7d8 = keccak256(validators(address))
    # 4a812dd3 = keccak256(validatorsMetadata(address))
    # IO.inspect [validator_address]
    # IO.puts Base.encode16(validator_address)
    %{"4a812dd3" => {:ok, fields}} =
      Reader.query_contract(
        config(:metadata_contract_address),
        contract_abi("metadata.json"),
        %{
          "4a812dd3" => [validator_address]
        },
        false
      )

    fields
  end

  defp translate_metadata([
         first_name,
         last_name,
         contactEmail,
         researchInstitute,
         researchField,
         instituteAddress,
         sender
       ]) do
    %{
      name: researchInstitute,
      metadata: %{
        license_id: first_name <> " " <> last_name,
	researchField: researchField,
        address: instituteAddress,
      }
    }
  end

  defp trim_null_bytes(bytes) do
    String.trim_trailing(bytes, <<0>>)
  end

  defp config(key) do
    Application.get_env(:explorer, __MODULE__, [])[key]
  end

  # sobelow_skip ["Traversal"]
  defp contract_abi(file_name) do
    :explorer
    |> Application.app_dir("priv/contracts_abi/poa/#{file_name}")
    |> File.read!()
    |> Jason.decode!()
  end
end
