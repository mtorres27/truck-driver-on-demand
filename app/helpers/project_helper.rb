module ProjectHelper
  def project_reference(project)
    "#{project.name} - #{project.external_project_id || project.id}"
  end
end
