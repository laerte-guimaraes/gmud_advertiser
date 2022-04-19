module PullRequestParser
  module_function

  def gmud_hash(gmud)
    description = {
      repository: gmud['head']['repo']['name'].capitalize,
      number: gmud['number'],
      link: gmud['html_url'],
      raw_description: gmud['body'],
      changes: '',
      riskiness: '' 
    }

    topic = nil

    gmud['body']&.each_line do |line|
      if line.include?('## O que mudou')
        topic = :changes
        next
      elsif line.include?('## Riscos')
        topic = :riskiness
        next
      elsif line.include?('## Impactos negativos previstos')
        break
      end

      description[topic]&.concat(line) unless line.strip.empty?
    end

    description
  rescue StopIteration
    description
  end
end
