function alignment = fixed_alignment(sec, rel_to)
%FIXED_ALIGNMENT Returns an alignment that's fixed relative to another alignment.
% Usage:
%   alignment = fixed_alignment(sec)
%   alignment = fixed_alignment(sec, rel_to)

if nargin < 2
    alignments = fieldnames(sec.alignments);
    alignment = alignments{end};
end

fprintf('Keeping section %d fixed with respect to alignment ''%s''.\n', sec.num, rel_to)

alignment.tforms = sec.alignments.(rel_to).tforms;
alignment.rel_tforms = repmat({affine2d()}, size(alignment.tforms));
alignment.rel_to = rel_to;
alignment.meta.method = 'fixed';
alignment.meta.avg_prior_error = NaN;
alignment.meta.avg_post_error = NaN;

end

