RSpec.describe Problems::Client::Yaml do
  let(:client) { Problems::Client.new }

  describe '.transform' do
    context 'for unexisted file' do
      it 'returns error' do
        result = client.transform(filename: './spec/fixtures/translations_simple_unexisted.yml', save_dir: './spec/fixtures/')

        expect(result).to eq('error' => 'File is not exist')
      end
    end

    context 'for unexisted save dir' do
      it 'returns error' do
        result = client.transform(filename: './spec/fixtures/translations_simple.yml', save_dir: './spec/fixtures_unexisted/')

        expect(result).to eq('error' => 'Save dir is not exist')
      end
    end

    context 'for invalid file content' do
      it 'returns error' do
        result = client.transform(filename: './spec/fixtures/translations_simple_invalid.yml', save_dir: './spec/fixtures/')

        expect(result).to eq('error' => 'Content format error')
      end
    end

    context 'for valid data' do
      it 'creates yml file' do
        client.transform(filename: './spec/fixtures/translations_simple.yml', save_dir: './spec/fixtures/')

        expect(File.file?('./spec/fixtures/translation.yml')).to eq true
      end
    end
  end

  describe 'methods' do
    context '.check_for_existed_keys' do
      context 'for unexisted key' do
        it 'merge new hash to existed and returns hash' do
          result = client.send(:check_for_existed_keys, {}, ['dog'], 'Dog')

          expect(result.is_a?(Hash)).to eq true
          expect(result).to eq('dog' => 'Dog')
        end
      end

      context 'for existed key' do
        it 'update hash at existed key by adding new pair and returns hash' do
          result = client.send(:check_for_existed_keys, { 'pets' => { 'cat' => 'Cat' } }, ['pets', 'dog'], 'Dog')

          expect(result.is_a?(Hash)).to eq true
          expect(result).to eq('pets' => { 'cat' => 'Cat', 'dog' => 'Dog' })
        end
      end
    end

    context '.generate_hash' do
      context 'for 1 key' do
        it 'returns hash' do
          result = client.send(:generate_hash, ['dog'], 'Dog')

          expect(result.is_a?(Hash)).to eq true
          expect(result).to eq('dog' => 'Dog')
        end
      end

      context 'for more then 1 key' do
        it 'returns hash' do
          result = client.send(:generate_hash, ['pets', 'dog'], 'Dog')

          expect(result.is_a?(Hash)).to eq true
          expect(result).to eq('pets' => { 'dog' => 'Dog' })
        end
      end
    end
  end
end
