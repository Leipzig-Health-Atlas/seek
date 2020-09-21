module PhenotypeAlgorithmHelper

	def render_phenotype_formula(formula, variables)
		if variables
			variables.each do |variable|
				formula.gsub! variable, link_to(variable, '#' + variable, html_options = { class: 'btn btn-default btn-sm' })
			end
		end

		formula
	end

	def render_phenotype_datatype(datatype)
		case datatype.downcase
		when 'number'
			'<i class="glyphicon glyphicon-scale" title="Number"></i>'
		when 'text'
			'<i class="glyphicon glyphicon-font" title="Text"></i>'
		when 'date'
			'<i class="glyphicon glyphicon-calendar" title="Date"></i>'
		else
			'<i class="glyphicon glyphicon-th-large" title="Composite"></i>'
		end
	end

end