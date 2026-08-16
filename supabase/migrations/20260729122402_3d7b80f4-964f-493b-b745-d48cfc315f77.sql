CREATE POLICY "Usuários autenticados podem apagar agendamentos de consulta"
ON public.agendamentos_consulta
FOR DELETE
TO authenticated
USING (true);